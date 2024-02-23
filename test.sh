#!/bin/sh

IMAGE=debian-s6
VERSION=`cat VERSION`
DEBIAN=${1:-12}
TAG=${IMAGE}-test

docker buildx build \
    --load \
    --build-arg BF_IMAGE=${IMAGE} \
    --build-arg BF_VERSION=${VERSION} \
    -f ${DEBIAN}/Dockerfile \
    -t ${TAG} \
    . \
    && \
    docker run --entrypoint "/usr/bin/env" ${TAG} -i nu -c "use bf test ; test"
