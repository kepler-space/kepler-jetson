DESCRIPTION = "Packagegroup for all Kepler Jetson images"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
    ${MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS} \
    kepler-ecg-ip-config \
    kepler-ssd-format \
    kepler-obc-uart \
    kernel-module-at24 \
    less \
    ncurses-terminfo-base \
    os-release \
    procps \
    systemd-conf \
    vim \
"

# Jetson specific
RDEPENDS:${PN}:append:tegra = "\
    nv-tegra-release \
    swupdate-machine-config \
    tegra-eeprom-tool \
    tegra-tools-tegrastats \
"
