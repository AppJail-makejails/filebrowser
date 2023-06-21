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

* `filebrowser_tag` (default: `latest`): see [#tags](#tags).

## How to build the Image

Make any changes you want to your image.

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/filebrowser --file build.makejail

SYSRC filebrowser_enable=YES
SERVICE filebrowser start
```

Build the jail:

```sh
appjail makejail -j filebrowser -- \
    --filebrowser_options "$PWD/options/network.makejail"
```

Remove unportable or unnecessary files and directories and export the jail:

```sh
appjail sysrc jail filebrowser -x defaultrouter
appjail stop filebrowser
appjail cmd local filebrowser sh -c "rm -f var/log/*"
appjail cmd local filebrowser rm -f var/db/filebrowser/filebrowser.db
appjail image export filebrowser
```

### Arguments

* `filebrowser_builder` (default: `filebrowserb`): Makejail builder name.
* `filebrowser_options` (mandatory): Makejail that contains options for the Makejail builder. This Makejail is intended for passing network options. An absolute path must be passed.

## Tags

* `latest` (osarch: `amd64`, osversion: `13.2-RELEASE`).
