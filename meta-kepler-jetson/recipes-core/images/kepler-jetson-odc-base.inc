IMAGE_FEATURES += "ssh-server-openssh"

inherit core-image
inherit nopackages

CORE_IMAGE_BASE_INSTALL += "packagegroup-kepler-jetson-odc-base"
