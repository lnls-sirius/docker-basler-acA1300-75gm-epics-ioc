#!/usr/bin/env bash

set -u

if [ -z "$BASLER_INSTANCE" ]; then
    echo "BASLER_INSTANCE environment variable is not set." >&2
    exit 1
fi

/usr/bin/docker stop \
    basler-aca1300-75gm-epics-ioc-${BASLER_INSTANCE}
