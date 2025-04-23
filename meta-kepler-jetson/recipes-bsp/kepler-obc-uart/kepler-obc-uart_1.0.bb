DESCRIPTION = "Kepler OBC UART login service"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://serial-ttyTHS1.service \
"

inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd"

inherit systemd

SYSTEMD_AUTO_ENABLE:${PN} = "enable"
SYSTEMD_SERVICE:${PN} = "serial-ttyTHS1.service"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/serial-ttyTHS1.service ${D}${systemd_system_unitdir}
}

FILES:${PN} += "${systemd_system_unitdir}/serial-ttyTHS1.service"
