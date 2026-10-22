DESCRIPTION = "Packagegroup for Kepler's development Jetson image"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    chrony \
    chronyc \
    iperf3 \
    lrzsz \
    rsyslog \
    stress-ng \
    sudo \
"

# Jetson specific
RDEPENDS:${PN}:append:tegra = "\
    cuda-samples \
    python3-jetson-stats \
"
