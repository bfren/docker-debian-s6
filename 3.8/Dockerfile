FROM --platform=$BUILDPLATFORM golang:alpine AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM

RUN echo "Build: $BUILDPLATFORM, target: $TARGETPLATFORM" > /log

FROM bfren/alpine:alpine3.8.5-1.6.7
COPY --from=build /log /log

LABEL org.opencontainers.image.source="https://github.com/bfren/docker-alpine-s6"

ARG TARGETPLATFORM

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
