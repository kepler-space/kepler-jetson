FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-TegraSerialPortLib-restore-16550-UART-detection.patch;patchdir=../edk2-nvidia"

# The original NVIDIA source we are patching uses CRLF line endings. 
# We need to normalize to use LF endings beforing ptaching.
do_normalize_tegra_serial_crlf() {
    target="${S}/../edk2-nvidia/Silicon/NVIDIA/Library/TegraSerialPortLib/TegraSerialPortLib.c"

    [ -f "$target" ] || bbfatal "Could not find $target"
    perl -pi -e 's/\r\n/\n/g' "$target"
}

addtask normalize_tegra_serial_crlf after do_unpack before do_patch
