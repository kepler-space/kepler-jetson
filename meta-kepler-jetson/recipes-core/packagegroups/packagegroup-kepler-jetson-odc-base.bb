DESCRIPTION = "Packagegroup for all Kepler Jetson images"

LICENSE = "CLOSED"

inherit packagegroup

RDEPENDS:${PN} = "\
    ${MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS} \
    less \
    ncurses-terminfo-base \
    nv-tegra-release \
    os-release \
    procps \
    systemd-conf \
    tegra-tools-tegrastats \
    vim \
"
