DESCRIPTION = "Kepler Jetson Development Image"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

require kepler-jetson-odc-base.inc

IMAGE_FEATURES += "package-management"

CORE_IMAGE_EXTRA_INSTALL += "packagegroup-kepler-jetson-odc-dev"

inherit extrausers

ROOT_PASSWD = "\$5\$Z/eBz2GV.Vg/4ygy\$qwRpubYRdkdRQoxYTfC46jvMQpTGbhLPh/l53e4HjPA"
KEPLER_PASSWD = "\$5\$Sdxp/vN09rfswz/A\$.m2bPR.p0hA8dY0xD9qKq1XBYd0do6tIDxyGO3RvSp8"
EXTRA_USERS_PARAMS = " \
    useradd -u 1000 kepler; \
    usermod -p '${KEPLER_PASSWD}' kepler; \
    usermod -a -G sudo kepler; \
    usermod -p '${ROOT_PASSWD}' root; \
"
