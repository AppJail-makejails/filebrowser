# filebrowser

filebrowser provides a file managing interface within a specified directory and it can be used to upload, delete, preview, rename and edit your files. It allows the creation of multiple users and each user can have its own directory. It can be used as a standalone app.

filebrowser.org

<img src="https://raw.githubusercontent.com/filebrowser/filebrowser/master/frontend/public/img/logo.svg" width="60%" height="auto" alt="filebrowser logo">

## How to use this Makejail

### Basic usage

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/filebrowser

OPTION expose=8080
```

Where `options/network.makejail` are the options that suit your environment, for example:

```
ARG network?
ARG interface=${APPJAIL_JAILNAME}

OPTION virtualnet=${network}:${interface} default
OPTION nat
```

Open a shell and run `appjail makejail`:

```sh
appjail makejail -j filebrowser
# or use a network explicitly
appjail makejail -j filebrowser -- --network development
```

### Adding users

You can modify the database to, for example, add users.

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/filebrowser

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

### Arguments

* `filebrowser_tag` (default: `13.2`): see [#tags](#tags).

### Volumes

| Name            | Owner | Group | Perm | Type | Mountpoint                 |
| --------------- | ----- | ----- | ---- | ---- | -------------------------- |
| filebrowser-db  | 1001  | 1001  |  -   |  -   | /var/db/filebrowser        |
| filebrowser-www | 1001  | 1001  |  -   |  -   | /usr/local/www/filebrowser |

## Tags

| Tag    | Arch     | Version        | Type   |
| ------ | -------- | -------------- | ------ |
| `13.2` | `amd64`  | `13.2-RELEASE` | `thin` |
| `14.0` | `amd64`  | `14.0-RELEASE` | `thin` |
