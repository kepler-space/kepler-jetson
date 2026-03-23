FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

do_install:append() {
    install -d -m 0644 ${D}/mnt/persistent
}
