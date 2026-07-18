ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="File Browser" \
    org.opencontainers.image.description="Stylish web-based file browser" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/filebrowser" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/filebrowser" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U filebrowser; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/* /var/db/pkg/repos/*; \
    fi

COPY entrypoint.sh /

RUN chmod +x /entrypoint.sh && \
    mkdir -p /srv /config /database /defaults

COPY settings.json /defaults

VOLUME ["/srv", "/config", "/database"]

ENTRYPOINT ["/entrypoint.sh"]
