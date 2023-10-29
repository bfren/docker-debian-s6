#======================================================================================================================
# STAGE 0: install S6 overlay.
#======================================================================================================================

FROM --platform=${BUILDPLATFORM} golang:alpine AS build
ARG TARGETPLATFORM

WORKDIR /s6
RUN case "${TARGETPLATFORM}" in \
        linux/amd64) ARCH="x86_64" ;; \
        linux/arm/v7) ARCH="armhf" ;; \
        linux/arm64) ARCH="aarch64" ;; \
        *) echo "Unsupported target platform: ${TARGETPLATFORM}." && exit 1 ;; \
    esac && \
    printf "%s" "${ARCH}" > ARCH && \
    URL=https://github.com/just-containers/s6-overlay/releases/download/v3.1.5.0/s6-overlay && \
    wget ${URL}-${ARCH}.tar.xz && \
    wget ${URL}-${ARCH}.tar.xz.sha256 && \
    wget ${URL}-noarch.tar.xz && \
    wget ${URL}-noarch.tar.xz.sha256


#======================================================================================================================
# STAGE 1: get build information.
#======================================================================================================================

FROM bfren/debian:bullseye-3.0.0-dev
COPY --from=build /s6 /s6

LABEL org.opencontainers.image.description="Debian base image with S6 Overlay."
LABEL org.opencontainers.image.source="https://github.com/bfren/docker-debian-s6"

ARG BF_IMAGE
ARG BF_VERSION

ENV \
    # cron log levels are from 0 (most verbose) to 8 (default)
    BF_CRON_LOG_LEVEL=8 \
    # set to 0 to disable setting permissions using ch.d during init phase
    BF_ENABLE_INIT_CH=1 \
    # add S6 executables to PATH
    PATH=/command:${PATH} \
    # what the container do if one of the service scripts fails -
    #   0: continue silently (default)
    #   1: continue with warning
    #   2: stop the container
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    # disable S6 Overlay service timeout - handle by timeout-up instead
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    # location of S6 service directories
    S6_SERVICES_DIR=/run/s6-rc/servicedirs

COPY ./overlay /

RUN bf-build-add "S6 Overlay" "3.1.5.0" && \
    bf-install

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=5 \
    CMD healthcheck
