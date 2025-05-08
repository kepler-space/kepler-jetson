#!/bin/bash

set -Eeuo pipefail

get_current_slot() {
    local -r curslot="$(nvbootctrl get-current-slot)"
    if [[ "${curslot}" == "0" ]]; then
	    echo "a"
    elif [[ "${curslot}" == "1" ]]; then
	    echo "b"
    else
        exit 1
    fi
}

get_serial_number() {
    if [[ -e /run/mfgdata/serial-number ]]; then
        cat /run/mfgdata/serial-number
    elif [[ -e /sys/module/fuse_burn/parameters/tegra_chip_uid ]]; then
        cat /sys/module/fuse_burn/parameters/tegra_chip_uid
    else
        echo "unknown"
    fi
}

. /etc/os-release

BOOTSLOT="$(get_current_slot)"
SERIALNUMBER="$(get_serial_number)"

rm -f /run/swupdate/swupdate.cfg

sed -e"s,@SWVERSION@,${VERSION_ID}," \
    -e"s,@SERIALNUMBER@,${SERIALNUMBER}," \
    -e"s,@BOOTSLOT@,${BOOTSLOT}," \
    /usr/share/swupdate/swupdate.cfg.in > /run/swupdate/swupdate.cfg
