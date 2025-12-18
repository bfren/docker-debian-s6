#======================================================================================================================
# STAGE 0: download S6 overlay
#======================================================================================================================

FROM --platform=${BUILDPLATFORM} quay.io/bfren/alpine AS s6
ARG TARGETPLATFORM

WORKDIR /s6
RUN \
    # build a URL to download S6 binaries
    echo "Downloading S6 Overlay." && \
    case "${TARGETPLATFORM}" in \
        linux/amd64) ARCH="x86_64" ;; \
        linux/arm/v7) ARCH="armhf" ;; \
        linux/arm64) ARCH="aarch64" ;; \
        *) echo "Unsupported target platform: ${TARGETPLATFORM}." && exit 1 ;; \
    esac && \
    printf "%s" "${ARCH}" > ARCH && \
    URL=https://github.com/just-containers/s6-overlay/releases/download/v3.2.1.0/s6-overlay && \
    bf-wget ${URL}-${ARCH}.tar.xz && \
    bf-wget ${URL}-${ARCH}.tar.xz.sha256 && \
    bf-wget ${URL}-noarch.tar.xz && \
    bf-wget ${URL}-noarch.tar.xz.sha256


#======================================================================================================================
# STAGE 1: get overlay from Alpine S6 image
#======================================================================================================================

FROM quay.io/bfren/alpine AS alpine

WORKDIR /tmp
RUN \
    # get the overlay from the Alpine S6 base image
    echo "Cloning Alpine S6 overlay." && \
    apk add git && git clone --branch v6.1.1 https://github.com/bfren/docker-alpine-s6.git && \
    mv docker-alpine-s6/overlay /


#======================================================================================================================
# STAGE 2: create final image
#======================================================================================================================

FROM quay.io/bfren/debian:bookworm-5.1.1
COPY --from=s6 /s6 /s6
COPY --from=alpine /overlay /

LABEL org.opencontainers.image.description="Debian base image with S6 Overlay."
LABEL org.opencontainers.image.source="https://github.com/bfren/docker-debian-s6"

ARG BF_IMAGE
ARG BF_PUBLISHING
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
    # location of S6 service directories
    S6_SERVICES_DIR=/run/s6-rc/servicedirs

RUN \
    # add S6 Overlay to the build log
    bf-build-add "S6 Overlay" "3.2.1.0" && \
    # run standard bf installation executable
    bf-install

HEALTHCHECK --interval=1m --timeout=10s --start-period=5s --retries=5 \
    CMD healthcheck
