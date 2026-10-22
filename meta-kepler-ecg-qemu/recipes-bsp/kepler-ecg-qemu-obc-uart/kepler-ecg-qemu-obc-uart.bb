DESCRIPTION = "Login on the emulated ECG OBC UART"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "kepler-ecg-qemu"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit features_check
REQUIRED_DISTRO_FEATURES = "systemd"

# The 16550 UART standing in for the OBC UART. kepler-obc-uart only starts a
# login on the ECG's ttyTHS1.
KEPLER_QEMU_OBC_UART ?= "ttyS0"

S = "${WORKDIR}"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${sysconfdir}/systemd/system/getty.target.wants
    ln -s ${systemd_system_unitdir}/serial-getty@.service \
        ${D}${sysconfdir}/systemd/system/getty.target.wants/serial-getty@${KEPLER_QEMU_OBC_UART}.service
}

FILES:${PN} = "${sysconfdir}/systemd/system/getty.target.wants"
RDEPENDS:${PN} = "systemd-serialgetty"
