IMAGE_FEATURES += "ssh-server-openssh"

inherit core-image
inherit nopackages

CORE_IMAGE_EXTRA_INSTALL += "packagegroup-kepler-jetson-odc-base"
