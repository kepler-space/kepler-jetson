DESCRIPTION = "SSD formatting script"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://65-kepler-ssd.rules \
    file://kepler-ssd-format.sh \
"

RDEPENDS:${PN} += "e2fsprogs-mke2fs udev util-linux-fdisk"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/kepler-ssd-format.sh ${D}${bindir}/kepler-ssd-format

    install -d ${D}${sysconfdir}/udev/rules.d/
    install -m 0644 ${WORKDIR}/65-kepler-ssd.rules ${D}${sysconfdir}/udev/rules.d/
}
