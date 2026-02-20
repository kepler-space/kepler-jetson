#!/usr/bin/env bash
#
# Generate a systemd network config file for kepler-ecg based on the detected blade slot.

set -Eeuo pipefail

readonly GATEWAY_HOSTNAME="kepler-mpcu.local"

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
readonly FALLBACK_BLADE_IP="192.168.109.1/24"

declare -rA GATEWAY_ID_IPS=(
    ["4"]="192.168.255.4"
    ["3"]="192.168.255.6"
    ["5"]="192.168.255.8"
    ["7"]="192.168.255.10"
)
readonly FALLBACK_GATEWAY_IP="192.168.109.10"

declare -rA ID_HOSTNAMES=(
    ["4"]="ecg0"
    ["3"]="ecg1"
    ["5"]="ecg2"
    ["7"]="ecg3"
)
FALLBACK_HOSTNAME="ecg0"

blade_id_bin=$(gpioget -c "${BLADE_ID_CHIP}" --numeric "${BLADE_ID_PINS[@]}" | tr -d "[:space:]")
blade_id=$(( 2#${blade_id_bin} ))

if [[ "${BLADE_ID_IPS[${blade_id}]+x}" ]]; then
    blade_ip="${BLADE_ID_IPS[${blade_id}]}"
    gateway_ip="${GATEWAY_ID_IPS[${blade_id}]}"
    hostname="${ID_HOSTNAMES[${blade_id}]}"
    echo "Detected blade slot ${blade_id}. Using IP ${blade_ip}"
else
    blade_ip="${FALLBACK_BLADE_IP}"
    gateway_ip="${FALLBACK_GATEWAY_IP}"
    hostname="${FALLBACK_HOSTNAME}"
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
if [[ "${blade_id}" != "${FALLBACK_BLADE_IP}" ]]; then
    cat <<EOF >> /lib/systemd/network/50-eth0.network

[Address]
Label=eth0:1
Address=${FALLBACK_BLADE_IP}
EOF
fi

# Add an entry to /etc/hosts so other services can resolve to the correct IP
if grep -q "${GATEWAY_HOSTNAME}" /etc/hosts; then
    sed -i "s/.*${GATEWAY_HOSTNAME}/${gateway_ip} ${GATEWAY_HOSTNAME}/" /etc/hosts
else
    echo "${gateway_ip} ${GATEWAY_HOSTNAME}" >> /etc/hosts
fi

hostname "${hostname}"
