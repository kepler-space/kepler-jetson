FILESEXTRAPATHS:prepend:kepler-ecg-qemu := "${THISDIR}/${PN}:"
SRC_URI:append:kepler-ecg-qemu = " file://kepler-ecg-qemu-ip-config-blade-id-chip.patch;patchdir=${WORKDIR}"

PACKAGE_ARCH:kepler-ecg-qemu = "${MACHINE_ARCH}"
