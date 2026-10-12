#!/bin/sh

IMAGE=debian-s6
VERSION=`cat VERSION`
DEBIAN=${1:-13}
TAG=${IMAGE}-test

docker buildx build \
    --no-cache-filter alpine \
    --load \
    --build-arg BF_IMAGE=${IMAGE} \
    --build-arg BF_VERSION=${VERSION} \
    -f ${DEBIAN}/Dockerfile \
    -t ${TAG} \
    . \
    && \
    docker run --entrypoint /test ${TAG}
