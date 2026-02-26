FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
SRC_URI += "\
    file://kepler-ecg-v1-disable-unused-features.cfg \
    file://kepler-ecg-v1-enable-sctp.cfg \
"
