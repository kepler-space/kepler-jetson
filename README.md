# Kepler Jetson Linux

## Quick Start

Clone the repo

```bash
git clone https://gitlab.i.kepler.engineering/kepler/kepler-jetson.git
cd kepler-jetson
```

Install Yocto dependencies

```bash
sudo apt install \
    build-essential \
    chrpath \
    cpio \
    debianutils \
    diffstat \
    file \
    gawk \
    gcc \
    git \
    iputils-ping \
    libacl1 \
    liblz4-tool \
    locales \
    python3 \
    python3-git \
    python3-jinja2 \
    python3-pexpect
    python3-pip \
    python3-subunit
    socat \
    texinfo \
    unzip \
    wget \
    xz-utils \
    zstd \
```

Install `kas`

```bash
pip3 install kas
```

Build the image

```bash
kas build kas-kepler-jetson.yml
```

Flashing over USB with Jetson in recovery mode

```bash
rm -rf /tmp/kepler-jetson
cp build/tmp/deploy/images/kepler-ecg-v1/kepler-jetson-odc-dev-kepler-ecg-v1.rootfs.tegraflash.tar.gz /tmp/kepler-jetson/
pushd /tmp/kepler-jetson
tar xf kepler-jetson-odc-dev-kepler-ecg-v1.rootfs.tegraflash.tar.gz
sudo ./doflash.sh
popd
```

OTA flashing with `swupdate`

```bash
scp build/tmp/deploy/images/kepler-ecg-v1/swupdate-image-tegra-kepler-ecg-v1.rootfs.swu root@192.168.109.1:
ssh root@192.168.109.1 "swupdate -i swupdate-image-tegra-kepler-ecg-v1.rootfs.swu"
ssh root@192.168.109.1 "reboot"
```
