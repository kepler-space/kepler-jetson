DESCRIPTION = "Packagegroup for Kepler's development Jetson image"

LICENSE = "CLOSED"

inherit packagegroup

RDEPENDS:${PN} = "\
    cuda-samples \
    iperf3 \
    lrzsz \
    python3-jetson-stats \
    stress-ng \
    sudo \
"
