FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
SRC_URI:append = "\
    file://tegra234-mb1-bct-gpio-default-kepler-ecg-v1.dtsi \
    file://tegra234-mb1-bct-padvoltage-default-kepler-ecg-v1.dtsi \
    file://tegra234-mb1-bct-pinmux-kepler-ecg-v1.dtsi \
    file://tegra234-mb1-bct-misc-kepler-ecg-v1.dts \
    file://tegra234-mb2-bct-misc-kepler-ecg-v1.dts \
"

# Hack: As the fetch task is disabled for this recipe, we have to directly access the files."
CUSTOM_DTSI_DIR := "${THISDIR}/${BPN}"
do_install:append() {
    install -m 0644 ${CUSTOM_DTSI_DIR}/tegra234-mb1-bct-gpio-default-kepler-ecg-v1.dtsi ${D}${datadir}/tegraflash/
    install -m 0644 ${CUSTOM_DTSI_DIR}/tegra234-mb1-bct-padvoltage-default-kepler-ecg-v1.dtsi ${D}${datadir}/tegraflash/
    install -m 0644 ${CUSTOM_DTSI_DIR}/tegra234-mb1-bct-pinmux-kepler-ecg-v1.dtsi ${D}${datadir}/tegraflash/
    install -m 0644 ${CUSTOM_DTSI_DIR}/tegra234-mb1-bct-misc-kepler-ecg-v1.dts ${D}${datadir}/tegraflash/
    install -m 0644 ${CUSTOM_DTSI_DIR}/tegra234-mb2-bct-misc-kepler-ecg-v1.dts ${D}${datadir}/tegraflash/
}
