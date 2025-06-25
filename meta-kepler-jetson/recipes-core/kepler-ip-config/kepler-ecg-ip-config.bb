DESCRIPTION = "Blade ID based IP configuration"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://kepler-ecg-ip-config.sh \
    file://kepler-ecg-ip-config.service \
"

inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd"

inherit systemd

SYSTEMD_AUTO_ENABLE:${PN} = "enable"
SYSTEMD_SERVICE:${PN} = "kepler-ecg-ip-config.service"

RDEPENDS:${PN} += "libgpiod libgpiod-tools"

do_install() {
    # Install scripts
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/kepler-ecg-ip-config.sh ${D}${bindir}/kepler-ecg-ip-config

    # Install systemd service
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/kepler-ecg-ip-config.service ${D}${systemd_system_unitdir}/kepler-ecg-ip-config.service
}

FILES:${PN} += "${systemd_system_unitdir}/kepler-ecg-ip-config.service"
