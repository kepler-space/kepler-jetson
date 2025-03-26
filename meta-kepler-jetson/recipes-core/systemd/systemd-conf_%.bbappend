FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://eth0.network"

do_install:append() {
  install -m 0644 ${WORKDIR}/eth0.network ${D}${systemd_unitdir}/network/50-eth0.network
}
