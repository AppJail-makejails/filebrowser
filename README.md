# filebrowser

filebrowser provides a file managing interface within a specified directory and it can be used to upload, delete, preview, rename and edit your files. It allows the creation of multiple users and each user can have its own directory. It can be used as a standalone app.

<img src="https://raw.githubusercontent.com/filebrowser/filebrowser/master/frontend/public/img/logo.svg" width="60%" height="auto" alt="filebrowser logo">

## How to use this Makejail

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

### Arguments

* `filebrowser_tag` (default: `latest`): see [#tags](#tags).

## How to build the Image

```sh
appjail makejail -j filebrowser -f "gh+AppJail-makejails/filebrowser --file build.makejail" -- --filebrowser_options "$PWD/options/network.makejail"
appjail image export filebrowser
```

### Arguments

* `filebrowser_builder` (default: `filebrowserb`): Makejail builder name.
* `filebrowser_options` (mandatory): Makejail that contains options for the Makejail builder. This Makejail is intended for passing network options.

## Tags

* `latest` (osarch: `amd64`, osversion: `13.2-RELEASE`).