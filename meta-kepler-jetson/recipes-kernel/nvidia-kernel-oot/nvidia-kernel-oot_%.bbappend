FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
SRC_URI:append = "\
    file://tegra234-kepler-ecg-v1.dts \
    file://tegra234-kepler-ecg-v1.patch \
    file://tegra234-kepler-ecg-v1-dynamic.dts \
    file://tegra234-kepler-ecg-v1-dynamic.patch \
"

copy_kepler_dts() {
    cp ${WORKDIR}/tegra234-kepler-ecg-v1.dts ${S}/hardware/nvidia/t23x/nv-public/nv-platform/
    cp ${WORKDIR}/tegra234-kepler-ecg-v1-dynamic.dts ${S}/hardware/nvidia/t23x/nv-public/overlay/
}

do_unpack[postfuncs] += "copy_kepler_dts"
