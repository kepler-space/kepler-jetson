DESCRIPTION = "Packagegroup for Kepler's development Jetson image"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit packagegroup

RDEPENDS:${PN} = "\
    chrony \
    chronyc \
    cuda-samples \
    iperf3 \
    lrzsz \
    python3-jetson-stats \
    stress-ng \
    sudo \
"
