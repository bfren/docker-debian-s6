FROM --platform=${BUILDPLATFORM} golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

WORKDIR /s6

RUN case "${TARGETPLATFORM}" in \
        linux/amd64) ARCH="x86_64" ;; \
        linux/arm/v7) ARCH="armhf" ;; \
        linux/arm64) ARCH="aarch64" ;; \
        *) echo "Unsupported target platform: ${TARGETPLATFORM}." && exit 1 ;; \
    esac && \
    echo "${ARCH}" > arch && \
    echo "Build: ${BUILDPLATFORM}" > /log && \
    echo "Target: ${TARGETPLATFORM}" >> /log && \
    echo "Arch: ${ARCH}" >> /log && \
    echo "S6 Overlay: 3.1.2.0" >> /log && \
    URL=https://github.com/just-containers/s6-overlay/releases/download/v3.1.2.0/s6-overlay && \
    apk add curl && \
    curl -sSL -O ${URL}-${ARCH}.tar.xz && \
    curl -sSL -O ${URL}-${ARCH}.tar.xz.sha256 && \
    curl -sSL -O ${URL}-noarch.tar.xz && \
    curl -sSL -O ${URL}-noarch.tar.xz.sha256

FROM bfren/debian:debian10.12-1.1.1
COPY --from=build /log /log
COPY --from=build /s6 /s6

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-debian-s6"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # add S6 executables to PATH
    PATH=/command:${PATH}

ENV \
    # cron log levels are from 0 (most verbose) to 8 (default)
    BF_CRON_LOG_LEVEL=8 \
    # disable S6 Overlay service timeout - handle by timeout-up instead
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0

COPY ./overlay /

RUN bf-install

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 CMD [ "healthcheck" ]

ENTRYPOINT [ "/init" ]
