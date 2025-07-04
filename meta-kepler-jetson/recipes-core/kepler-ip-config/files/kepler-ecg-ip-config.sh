#!/usr/bin/env bash
#
# Generate a systemd network config file for kepler-ecg based on the detected blade slot.

set -Eeuo pipefail

readonly BLADE_ID_CHIP="gpiochip0"
readonly BLADE_ID_PINS=(
    "109"
    "127"
    "98"
    "104"
    "96"
)
declare -rA BLADE_ID_IPS=(
    ["4"]="192.168.255.5/31"
    ["3"]="192.168.255.7/31"
    ["5"]="192.168.255.9/31"
    ["7"]="192.168.255.11/31"
)
readonly FALLBACK_IP="192.168.109.1/24"

blade_id_bin=$(gpioget -c "${BLADE_ID_CHIP}" --numeric "${BLADE_ID_PINS[@]}" | tr -d "[:space:]")
blade_id=$(( 2#${blade_id_bin} ))

if [[ -n "${BLADE_ID_IPS[${blade_id}]}" ]]; then
    blade_ip="${BLADE_ID_IPS[${blade_id}]}"
    echo "Detected blade slot ${blade_id}. Using IP ${blade_ip}"
else
    blade_ip="${FALLBACK_IP}"
    echo "Detected invalid blade slot ${blade_id}. Using IP ${blade_ip}"
fi

cat <<EOF > /lib/systemd/network/50-eth0.network
[Match]
Name=eth0

[Network]
DHCP=ipv4

[Address]
Label=eth0:0
Address=${blade_ip}
EOF

# Keep the fallback IP as a secondary address for backwards compatibility
if [[ "${blade_id}" != "${FALLBACK_IP}" ]]; then
    cat <<EOF >> /lib/systemd/network/50-eth0.network

[Address]
Label=eth0:1
Address=${FALLBACK_IP}
EOF
fi
