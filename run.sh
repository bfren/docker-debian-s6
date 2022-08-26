#!/bin/sh

IMAGE=`cat VERSION`
ALPINE=${1:-3.16}

docker buildx build \
    --build-arg BF_IMAGE=alpine-s6 \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${ALPINE}/Dockerfile \
    -t alpine${ALPINE}-s6-dev \
    . \
    && \
    docker run -it alpine${ALPINE}-s6-dev sh
