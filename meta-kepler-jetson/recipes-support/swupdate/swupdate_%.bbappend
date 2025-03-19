FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "\
    file://systemd.cfg \
    file://hash.cfg \
    file://part-format.cfg \
    file://archive.cfg \
    file://disable-uboot.cfg \
"

DEPENDS += "e2fsprogs"

do_install:append() {
    rm -rf ${D}${sysconfdir}/swupdate.cfg

    install -d ${D}${datadir}/lua/5.4
    install -m 0755 ${S}/handlers/lua/fpga.lua ${D}${datadir}/lua/5.4/
    install -m 0755 ${S}/handlers/lua/swupdate_handlers.lua ${D}${datadir}/lua/5.4/
}

RDEPENDS:${PN} += "os-release"
RDEPENDS:${PN} += "swupdate-machine-config"
FILES_${PN}:remove = "${sysconfdir}/swupdate.cfg"
FILES:${PN} += "${datadir}/lua"
