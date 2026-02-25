FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
SRC_URI += "\
    file://kepler-ecg-v1-disable-ktimer.cfg \
    file://kepler-ecg-v1-disable-unused-features.cfg \
"
