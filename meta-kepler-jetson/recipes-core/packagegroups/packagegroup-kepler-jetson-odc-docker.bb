DESCRIPTION = "Packagegroup for Docker on Kepler ODC Jetson"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit packagegroup

RDEPENDS:${PN} = "\
    bridge-utils \
    iptables \
    iptables-modules \
    iptables-module-xt-conntrack \
    iptables-module-xt-ct \
    iptables-module-xt-nat \
    nvidia-docker \
    kernel-module-bridge \
    kernel-module-br-netfilter \
    kernel-module-ip-tables \
    kernel-module-ipt-reject \
    kernel-module-iptable-filter \
    kernel-module-iptable-mangle \
    kernel-module-iptable-nat \
    kernel-module-macvlan \
    kernel-module-nf-conntrack-netlink \
    kernel-module-veth \
    kernel-module-xt-addrtype \
    kernel-module-xt-checksum \
    kernel-module-xt-conntrack \
    kernel-module-xt-masquerade \
    kernel-module-xt-nat \
    kernel-module-xt-redirect \
    kernel-module-xt-tcpudp \
"
