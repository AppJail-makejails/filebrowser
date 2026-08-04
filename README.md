# File Browser

File Browser provides a file managing interface within a specified directory and it can be used to upload, delete, preview, rename and edit your files. It allows the creation of multiple users and each user can have its own directory. It can be used as a standalone app.

filebrowser.org

<img src="https://raw.githubusercontent.com/filebrowser/filebrowser/master/frontend/public/img/logo.svg" width="30%" height="auto" alt="File Browser logo">

## How to use this Makejail

### Standalone

```console
$ mkdir -p \
    /var/appjail-volumes/srv \
    /var/appjail-volumes/database \
    /var/appjail-volumes/config
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o fstab="/var/appjail-volumes/srv /srv" \
    -o fstab="/var/appjail-volumes/database /database" \
    -o fstab="/var/appjail-volumes/config /config" \
    -o expose="80:8080" \
    ghcr.io/appjail-makejails/filebrowser filebrowser
```

### Deploy using `appjail-director`

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  filebrowser:
    makejail: gh+AppJail-makejails/filebrowser
    options:
      - container: 'args:--pull'
      - expose: '80:8080'
    volumes:
      - srv: /srv
      - database: /database
      - config: /config
    oci:
      environment:
        - PUID: 15000
        - PGID: 15000

volumes:
  srv:
    device: /var/appjail-volumes/filebrowser/srv
  database:
    device: /var/appjail-volumes/filebrowser/database
  config:
    device: /var/appjail-volumes/filebrowser/config
```

### Arguments (stage: build)

* `filebrowser_from` (default: `ghcr.io/appjail-makejails/filebrowser`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `filebrowser_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-2d07ddb3d6-database | `${PUID}` | `${PGID}` | - | - | /database |
| appjail-3e723ade99-config | `${PUID}` | `${PGID}` | - | - | /config |
| appjail-48d1ecb1ac-srv | `${PUID}` | `${PGID}` | - | - | /srv |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
