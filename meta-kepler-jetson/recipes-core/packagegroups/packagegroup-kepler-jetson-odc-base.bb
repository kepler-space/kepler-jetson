DESCRIPTION = "Packagegroup for all Kepler Jetson images"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit packagegroup

RDEPENDS:${PN} = "\
    ${MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS} \
    kepler-obc-uart \
    less \
    ncurses-terminfo-base \
    nv-tegra-release \
    os-release \
    procps \
    systemd-conf \
    tegra-tools-tegrastats \
    vim \
"
