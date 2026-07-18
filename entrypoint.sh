#!/bin/sh

. /lib.subr

set -e

create_user

chown -R noroot:noroot \
    /srv \
    /config \
    /database

# Ensure configuration exists
if [ ! -f "/config/settings.json" ]; then
    cp -a /defaults/settings.json /config/settings.json
fi

# Extract config file path from arguments
config_file=""
next_is_config=0
for arg in "$@"; do
    if [ "${next_is_config}" -eq 1 ]; then
        config_file="$arg"
        break
    fi
    case "${arg}" in
        -c|--config)
            next_is_config=1
            ;;
        -c=*|--config=*)
            config_file="${arg#*=}"
            break
            ;;
    esac
done

if [ -z "${config_file}" ]; then
    config_file="/config/settings.json"
    set -- --config=/config/settings.json "$@"
fi

chown -R noroot:noroot /srv /config /database

exec su-exec noroot filebrowser "$@"
