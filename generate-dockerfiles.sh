#!/bin/bash

set -euo pipefail

docker pull bfren/alpine

BASE_REVISION="1.2.0-beta"
S6_VERSION="3.1.2.1"
echo "Base: ${BASE_REVISION}"

DEBIAN_VERSIONS="10 11 12 sid"
for V in ${DEBIAN_VERSIONS} ; do

    echo "Debian ${V}"
    DEBIAN_MINOR=`cat ./${V}/DEBIAN_MINOR`

    DOCKERFILE=$(docker run \
        -v ${PWD}:/ws \
        -e BF_DEBUG=0 \
        bfren/alpine esh \
        "/ws/Dockerfile.esh" \
        BASE_REVISION=${BASE_REVISION} \
        S6_VERSION=${S6_VERSION} \
        DEBIAN_MINOR=${DEBIAN_MINOR}
    )

    echo "${DOCKERFILE}" > ./${V}/Dockerfile

done

docker system prune -f
echo "Done."
