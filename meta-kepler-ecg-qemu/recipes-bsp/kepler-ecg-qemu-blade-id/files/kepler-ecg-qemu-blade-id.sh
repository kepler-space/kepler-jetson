#!/bin/sh
#
# Simulate the ECG blade ID GPIOs with gpio-sim, so kepler-ecg-ip-config can
# detect a blade slot under QEMU. The blade ID is taken from the
# kepler.blade_id=<n> kernel parameter, and is 0 (no slot) if it is not set.

set -eu

# Must match BLADE_ID_PINS in kepler-ecg-ip-config, most significant bit first
readonly BLADE_ID_PINS="109 127 98 104 96"
readonly NUM_LINES="164"
readonly SIM_DIR="/sys/kernel/config/gpio-sim/blade-id"
readonly ENV_FILE="/run/kepler/blade-id.env"

blade_id=$(sed -n 's/.*kepler\.blade_id=\([0-9][0-9]*\).*/\1/p' /proc/cmdline)
blade_id="${blade_id:-0}"

mkdir -p "${SIM_DIR}/gpio-bank0"
echo "${NUM_LINES}" > "${SIM_DIR}/gpio-bank0/num_lines"
echo "blade-id-sim" > "${SIM_DIR}/gpio-bank0/label"
echo 1 > "${SIM_DIR}/live"

dev_name=$(cat "${SIM_DIR}/dev_name")
chip_name=$(cat "${SIM_DIR}/gpio-bank0/chip_name")

bit=4
for pin in ${BLADE_ID_PINS}; do
    if [ $(( (blade_id >> bit) & 1 )) -eq 1 ]; then
        pull="pull-up"
    else
        pull="pull-down"
    fi
    echo "${pull}" > "/sys/devices/platform/${dev_name}/${chip_name}/sim_gpio${pin}/pull"
    bit=$(( bit - 1 ))
done

mkdir -p "$(dirname "${ENV_FILE}")"
echo "BLADE_ID_CHIP=${chip_name}" > "${ENV_FILE}"
echo "Simulating blade ID ${blade_id} on ${chip_name}"
