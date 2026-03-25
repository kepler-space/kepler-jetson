#!/usr/bin/env bash
#
# Format and mount the selected SSD

set -Eeuo pipefail

readonly DEV_SSD1="${DEV_SSD1:-/dev/ssd1}"
readonly DEV_SSD1_P1="${DEV_SSD1_P1:-/dev/ssd1p1}"

readonly DEV_SSD2="${DEV_SSD2:-/dev/ssd2}"
readonly DEV_SSD2_P1="${DEV_SSD2_P1:-/dev/ssd2p1}"

die() {
    echo "$*" >&2
    exit 1
}

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] <ssd1|ssd2>

Format the selected SSD.

Available options:

-h, --help          Print this help and exit
-v, --verbose       Enable verbose output

<ssd1|ssd2>         Which SSD to format and mount.

EOF
    exit 0
}

parse_params() {
    while :; do
        case "${1-}" in
            -h | --help) usage ;;
            -v | --verbose) set -x ;;
            -?*) die "Unknown option: ${1}" ;;
            *) break ;;
        esac
        shift
    done

    if (( $# < 1 )); then
        die "Missing target. Expected 'ssd1' or 'ssd2'."
    fi

    target="${1-}"
    case "${target}" in
        ssd1)
            dev="${DEV_SSD1}"
            dev_p1="${DEV_SSD1_P1}"
            ;;
        ssd2)
            dev="${DEV_SSD2}"
            dev_p1="${DEV_SSD2_P1}"
            ;;
        *)
            die "Unsupported target: ${target}"
            ;;
    esac
}

format_drive() {
    local -r fdisk_cmds=(
        o   # Create a new partition table
        n   # Add a new partition
        p   # Make it a primary partition
        1   # Make it partition number 1.
        32  # Start at sector 32
        ""  # Blank line to accept end of the device as the last sector.
        w   # Write changes
    )

    printf '%s\n' "${fdisk_cmds[@]}" | fdisk "${dev}" &>/dev/null
    sleep 1
    mkfs.ext4 -F -O 64bit "${dev_p1}" &>/dev/null
}

main() {
    parse_params "$@"

    if [[ ! -b "${dev}" ]]; then
        echo "${target} not found."
        exit 1
    fi
    echo "${target} found."

    echo "Formatting ${target}..."
    format_drive
    if [[ ! -b "${dev_p1}" ]]; then
        echo "${target} not partitioned correctly."
        exit 1
    fi
    echo "${target} formatted."
}

main "$@"
