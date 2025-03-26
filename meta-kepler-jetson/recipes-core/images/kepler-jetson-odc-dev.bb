DESCRIPTION = "Kepler Jetson Development Image"
LICENSE = "CLOSED"

require kepler-jetson-odc-base.inc

IMAGE_FEATURES += "debug-tweaks"
IMAGE_FEATURES += "package-management"

CORE_IMAGE_BASE_INSTALL += "packagegroup-kepler-jetson-odc-dev"
