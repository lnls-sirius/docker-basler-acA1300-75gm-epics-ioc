#!/usr/bin/env bash

set -u

if [ -z "$BASLER_INSTANCE" ]; then
    echo "BASLER_INSTANCE environment variable is not set." >&2
    exit 1
fi

export BASLER_CURRENT_PV_AREA_PREFIX=BASLER_${BASLER_INSTANCE}_PV_AREA_PREFIX
export BASLER_CURRENT_PV_DEVICE_PREFIX=BASLER_${BASLER_INSTANCE}_PV_DEVICE_PREFIX
export BASLER_CURRENT_SERIAL_NUMBER=BASLER_${BASLER_INSTANCE}_SERIAL_NUMBER
# Only works with bash
export BASLER_PV_AREA_PREFIX=${!BASLER_CURRENT_PV_AREA_PREFIX}
export BASLER_PV_DEVICE_PREFIX=${!BASLER_CURRENT_PV_DEVICE_PREFIX}
export BASLER_SERIAL_NUMBER=${!BASLER_CURRENT_SERIAL_NUMBER}

# Create volume for autosave and ignore errors
/usr/bin/docker create \
    -v /opt/epics/startup/ioc/basler-acA1300-75gm-epics-ioc/iocBoot/iocBasleracA130075gm/autosave \
    --name basler-aca1300-75gm-epics-ioc-${BASLER_INSTANCE}-volume \
    lnlsdig/basler-aca1300-75gm-epics-ioc:${IMAGE_VERSION} \
    2>/dev/null || true

# Remove a possible old and stopped container with
# the same name
/usr/bin/docker rm \
    basler-aca1300-75gm-epics-ioc-${BASLER_INSTANCE} || true

/usr/bin/docker run \
    --net host \
    -t \
    --rm \
    --volumes-from basler-aca1300-75gm-epics-ioc-${BASLER_INSTANCE}-volume \
    --name basler-aca1300-75gm-epics-ioc-${BASLER_INSTANCE} \
    lnlsdig/basler-aca1300-75gm-epics-ioc:${IMAGE_VERSION} \
    -s "${BASLER_SERIAL_NUMBER}" \
    -P "${BASLER_PV_AREA_PREFIX}" \
    -R "${BASLER_PV_DEVICE_PREFIX}" \
