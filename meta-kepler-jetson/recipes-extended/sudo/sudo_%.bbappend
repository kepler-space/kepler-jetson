FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://allow-sudo-group.conf"

do_install:append() {
    install -D -m 440 ${WORKDIR}/allow-sudo-group.conf ${D}${sysconfdir}/sudoers.d/allow-sudo-group
}
