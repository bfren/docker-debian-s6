#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_VERSION="3.0.11"
ALPINE_BRANCH="v5.1.4"
S6_VERSION="3.1.6.2"

DEBIAN_VERSIONS="11 12 13"
for V in ${DEBIAN_VERSIONS} ; do

    echo "Debian ${V}"
    DEBIAN_NAME=`cat ./${V}/DEBIAN_NAME`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        ALPINE_BRANCH=${ALPINE_BRANCH} \
        BASE_VERSION=${BASE_VERSION} \
        S6_VERSION=${S6_VERSION} \
        DEBIAN_NAME=${DEBIAN_NAME}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
