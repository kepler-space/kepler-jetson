# The emulated SSD is identified by its serial number, and starts out blank
# unlike ECG SSDs
FILESEXTRAPATHS:prepend:kepler-ecg-qemu := "${THISDIR}/${PN}:"
SRC_URI:append:kepler-ecg-qemu = " file://kepler-ecg-qemu-ssd-format-blank-disk.patch;patchdir=${WORKDIR}"

PACKAGE_ARCH:kepler-ecg-qemu = "${MACHINE_ARCH}"
