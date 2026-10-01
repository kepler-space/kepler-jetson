FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
SRC_URI += "\
    file://kepler-ecg-v1-disable-ktimer.cfg \
    file://kepler-ecg-v1-disable-unused-features.cfg \
    file://kepler-ecg-v1-enable-sctp.cfg \
    file://0001-serial-tegra-do-not-ack-aborted-dma.patch \
"
