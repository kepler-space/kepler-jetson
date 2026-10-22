DESCRIPTION = "Blank disk image for the emulated ECG SSD"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "kepler-ecg-qemu"
PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit deploy nopackages

DEPENDS = "qemu-system-native"

KEPLER_QEMU_SSD_SIZE ?= "4G"

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_deploy() {
    # Grows as it is written to, and is left unformatted like a new SSD; use
    # kepler-ssd-format ssd1
    qemu-img create -f qcow2 ${DEPLOYDIR}/kepler-ecg-qemu-ssd1.qcow2 ${KEPLER_QEMU_SSD_SIZE}
}

addtask deploy after do_install
