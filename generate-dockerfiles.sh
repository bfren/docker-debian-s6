#!/bin/bash

set -euo pipefail

docker pull quay.io/bfren/alpine

BASE_VERSION="6.0.3"
ALPINE_BRANCH="v7.0.3"
S6_VERSION="3.2.3.2"

DEBIAN_VERSIONS="12 13"
for V in ${DEBIAN_VERSIONS} ; do

    echo "Debian ${V}"
    # the base is pinned to this exact point release, so a stale DEBIAN_MINOR fails the build
    DEBIAN_MINOR=`cat ./${V}/DEBIAN_MINOR`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        ALPINE_BRANCH=${ALPINE_BRANCH} \
        BASE_VERSION=${BASE_VERSION} \
        S6_VERSION=${S6_VERSION} \
        DEBIAN_MINOR=${DEBIAN_MINOR}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

echo "Done."
