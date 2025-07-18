# File Browser

File Browser provides a file managing interface within a specified directory and it can be used to upload, delete, preview, rename and edit your files. It allows the creation of multiple users and each user can have its own directory. It can be used as a standalone app.

filebrowser.org

<img src="https://raw.githubusercontent.com/filebrowser/filebrowser/master/frontend/public/img/logo.svg" width="60%" height="auto" alt="filebrowser logo">

## How to use this Makejail

### Basic usage

```sh
appjail makejail \
    -j filebrowser \
    -f gh+AppJail-makejails/filebrowser \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=8080
```

### Deploy using appjail-director

```sh
mkdir -p .volumes
```

**appjail-director.yml**:

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  filebrowser:
    name: filebrowser
    makejail: gh+AppJail-makejails/filebrowser
    options:
      - expose: 8080
    volumes:
      - db: filebrowser-db
      - log: filebrowser-log
      - www: filebrowser-www
    start-environment:
      - FB_NOAUTH: 1

default_volume_type: '<volumefs>'

volumes:
  db:
    device: .volumes/db
  log:
    device: .volumes/log
  www:
    device: .volumes/www
```

**.env**:

```
DIRECTOR_PROJECT=filebrowser
```

### Adding users

You can modify the database to, for example, add users.

```
INCLUDE gh+AppJail-makejails/filebrowser

OPTION virtualnet=:<random> default
OPTION nat
OPTION expose=8080

SERVICE filebrowser stop

CMD mkdir -p /usr/local/www/filebrowser/users/rscott
CMD chown filebrowser:filebrowser /usr/local/www/filebrowser/users/rscott

CMD mkdir -p /usr/local/www/filebrowser/users/mscorsese
CMD chown filebrowser:filebrowser /usr/local/www/filebrowser/users/mscorsese

WORKDIR /var/db/filebrowser
USER filebrowser

RUN filebrowser users add rscott american_gangster_2007 --scope /usr/local/www/filebrowser/users/rscott
RUN filebrowser users add mscorsese mean_streets_1973 --scope /usr/local/www/filebrowser/users/mscorsese

SERVICE filebrowser start
```

Refer to the filebrowser documentation for details.

### Arguments (stage: build)

* `filebrowser_tag` (default: `13.5`): see [#tags](#tags).
* `filebrowser_ajspec` (default: `gh+AppJail-makejails/filebrowser`): Entry point where the `appjail-ajspec(5)` file is located.

### Check current status

The custom stage `filebrowser_status` can be used to run `top(1)` to check the status of File Browser.

```sh
appjail run -s filebrowser_status filebrowser
```

### Log

To view the log generated by the web application, run the custom stage `filebrowser_log`.

```sh
appjail run -s filebrowser_log filebrowser
```

### Volumes

| Name            | Owner | Group | Perm | Type | Mountpoint                 |
| --------------- | ----- | ----- | ---- | ---- | -------------------------- |
| filebrowser-db  | 835   | 835   | 700  |  -   | /var/db/filebrowser        |
| filebrowser-log | 835   | 835   | 700  |  -   | /var/log/filebrowser       |
| filebrowser-www | 835   | 835   |  -   |  -   | /usr/local/www/filebrowser |

## Tags

| Tag        | Arch     | Version            | Type   |
| ---------- | -------- | ------------------ | ------ |
| `13.5` | `amd64`  | `13.5-RELEASE` | `thin` |
| `14.3` | `amd64`  | `14.3-RELEASE` | `thin` |
