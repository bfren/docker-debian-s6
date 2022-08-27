#!/bin/sh

IMAGE=`cat VERSION`
DEBIAN=${1:-11}

docker buildx build \
    --build-arg BF_IMAGE=debian-s6 \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${DEBIAN}/Dockerfile \
    -t debian${DEBIAN}-s6-dev \
    . \
    && \
    docker run -it debian${DEBIAN}-s6-dev bash
