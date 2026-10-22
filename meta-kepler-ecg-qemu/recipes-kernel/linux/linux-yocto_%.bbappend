FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI:append:kepler-ecg-qemu = " file://kepler-ecg-qemu.cfg"

# Use the qemuarm64 kernel BSP definition
KMACHINE:kepler-ecg-qemu = "qemuarm64"

# These are modules on the ECG, but built in with meta-virtualization's
# container config, so let the kernel provide the packages that
# packagegroup-kepler-jetson-odc-docker depends on
RPROVIDES:${KERNEL_PACKAGE_NAME}-base:append:kepler-ecg-qemu = " \
    kernel-module-bridge \
    kernel-module-br-netfilter \
    kernel-module-macvlan \
    kernel-module-md5 \
    kernel-module-veth \
"
