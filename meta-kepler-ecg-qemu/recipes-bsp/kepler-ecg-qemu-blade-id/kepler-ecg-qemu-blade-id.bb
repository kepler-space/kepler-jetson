DESCRIPTION = "Simulated ECG blade ID GPIOs for QEMU"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://kepler-ecg-qemu-blade-id.sh \
    file://kepler-ecg-qemu-blade-id.service \
"

COMPATIBLE_MACHINE = "kepler-ecg-qemu"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd"

inherit systemd

SYSTEMD_AUTO_ENABLE:${PN} = "enable"
SYSTEMD_SERVICE:${PN} = "kepler-ecg-qemu-blade-id.service"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/kepler-ecg-qemu-blade-id.sh ${D}${bindir}/kepler-ecg-qemu-blade-id

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/kepler-ecg-qemu-blade-id.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += "${systemd_system_unitdir}/kepler-ecg-qemu-blade-id.service"
