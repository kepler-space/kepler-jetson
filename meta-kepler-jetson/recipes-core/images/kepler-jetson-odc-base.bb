DESCRIPTION = "Kepler Jetson Base Image"
LICENSE = "CLOSED"

IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_FEATURES += "debug-tweaks"

inherit core-image
inherit nopackages
