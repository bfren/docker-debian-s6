#!/bin/sh

IMAGE=`cat VERSION`
DEBIAN=${1:-12}

docker buildx build \
    --load \
    --progress plain \
    --build-arg BF_IMAGE=debian-s6 \
    --build-arg BF_VERSION=${IMAGE} \
    -f ${DEBIAN}/Dockerfile \
    -t debian${DEBIAN}-s6-dev \
    . \
    && \
    docker run -it -e BF_DEBUG=1 debian${DEBIAN}-s6-dev sh
