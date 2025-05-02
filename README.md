# Kepler Jetson Linux

A custom Yocto-based Linux image for Kepler's ECG payloads. This project leverages the [meta-tegra](https://github.com/OE4T/meta-tegra) layer and draws inspiration from [tegra-demo-distro](https://github.com/OE4T/tegra-demo-distro).

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
  - [Cloning the Repository](#cloning-the-repository)
  - [Installing Dependencies](#installing-dependencies)
- [Building the Image](#building-the-image)
  - [32GB Variant](#32gb-variant)
  - [64GB Variant](#64gb-variant)
- [Flashing the Jetson](#flashing-the-jetson)
  - [USB Recovery Mode Flashing](#usb-recovery-mode-flashing)
  - [Connecting via UART Console](#connecting-via-uart-console)
  - [OTA Installation](#ota-installation)
- [Host Network Configuration](#host-network-configuration)
- [Connecting via SSH](#connecting-via-ssh)
- [Useful Jetson Commands](#useful-jetson-commands)
- [Customizing the Image](#customizing-the-image)
- [Development Tips](#development-tips)
- [Troubleshooting](#troubleshooting)
- [References](#references)

## Overview

This repository provides a customized Yocto-based Linux distribution specifically designed for Kepler's ECG payloads. It supports both 32GB and 64GB variants and includes:

- A streamlined build process using `kas`
- OTA update capability with `swupdate`
- Customization options for extending functionality
- Integration with NVIDIA's JetPack components via meta-tegra

While the image has been customized for Kepler's ECG payloads, it is still compatible with NVIDIA Jetson AGX Orin devkits.

## Getting Started

### Cloning the Repository

```bash
git clone https://github.com/kepler-space/kepler-jetson.git
cd kepler-jetson
```

### Installing Dependencies

Install required Yocto dependencies (Ubuntu 20.04/22.04 recommended):

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
    python3-pexpect \
    python3-pip \
    python3-subunit \
    socat \
    texinfo \
    unzip \
    wget \
    xz-utils \
    zstd
```

Install `kas` for build configuration management:

```bash
# Option 1: Global installation
pip3 install kas
```

Alternatively, you can install `kas` in a Python virtual environment (recommended):

```bash
# Option 2: Installation in a virtual environment
# Create a virtual environment in the project directory
python3 -m venv .venv

# Activate the virtual environment
source .venv/bin/activate

# Install kas within the virtual environment
pip install kas

# To deactivate the virtual environment when done
# deactivate
```

> **Note:** If you install kas in a virtual environment, remember to activate the environment (`source .venv/bin/activate`) each time you open a new terminal session before running kas commands.

## Building the Image

The project uses [kas](https://kas.readthedocs.io/) to manage build configurations.

### 32GB Variant

To build the image for the 32GB payload (default, matches ECG hardware):

```bash
# The 32GB variant is built by default
kas build kas-kepler-jetson.yml
```

### 64GB Variant

To build the image for the 64GB payload, set the `KAS_MACHINE` environment variable:

```bash
# Specify the 64GB variant using the KAS_MACHINE environment variable
KAS_MACHINE=kepler-ecg-v1-64gb kas build kas-kepler-jetson.yml
```

The build process will take some time depending on your hardware. Once complete, the output images will be found in `build/tmp/deploy/images/kepler-ecg-v1/` or `build/tmp/deploy/images/kepler-ecg-v1-64gb/` depending on which variant you built.

## Flashing a Jetson Devkit

### Devkit USB Recovery Mode Flashing

1. Put your Jetson AGX Orin devkit into recovery mode by holding the recovery button while pressing the reset button
2. Connect the Jetson to your host computer via USB
3. Flash the image using:

```bash
rm -rf /tmp/kepler-jetson
cp build/tmp/deploy/images/kepler-ecg-v1/kepler-jetson-odc-dev-kepler-ecg-v1.rootfs.tegraflash.tar.gz /tmp/kepler-jetson/
pushd /tmp/kepler-jetson
tar xf kepler-jetson-odc-dev-kepler-ecg-v1.rootfs.tegraflash.tar.gz
sudo ./doflash.sh
popd
```

### Devkit UART Console

After flashing, you can connect to the Jetson devkit's UART console:

1. Ensure the Jetson devkit is connected to your host machine via USB
2. Connect to the serial console:

```bash
sudo screen /dev/ttyACM0 115200
```

3. Log in with the following credentials:
   - Username: `kepler`
   - Password: `kepler`

> **Note:** Press `Ctrl+a` followed by `k` to exit the screen session when done.

### OTA Installation

For devices already running a compatible image, you can use OTA updates:

```bash
scp build/tmp/deploy/images/kepler-ecg-v1/swupdate-image-tegra-kepler-ecg-v1.rootfs.swu kepler@192.168.109.1:
ssh kepler@192.168.109.1 "sudo swupdate -i swupdate-image-tegra-kepler-ecg-v1.rootfs.swu"
ssh kepler@192.168.109.1 "sudo reboot"
```

Replace `192.168.109.1` with the IP address of your Jetson devkit.

> **Note:** On orbit, OTA is the only supported method of software updates.

## Host Network Configuration

To connect your host machine to the Jetson devkit's Ethernet port:

1. Connect an Ethernet cable between your host computer and the Jetson devkit
2. Configure your host's network interface with a static IP in the same subnet:

```bash
# Determine your ethernet interface name (e.g., eth0, enp3s0)
ip a

# Configure a static IP (assuming Jetson has IP 192.168.109.1)
sudo ip addr add 192.168.109.10/24 dev <interface_name>
sudo ip link set <interface_name> up

# Test connectivity
ping 192.168.109.1
```

For a persistent configuration, you can add this to your network configuration files (e.g., NetworkManager or netplan).

> **Note:** The host network configuration described above will only provide network connectivity between the host machine
and the Jetson dev kit. It will not provide the Jetson with network access to the internet. To allow internet access, you
will need to configure your host machine as a gateway. The exact configuration will depend on your network setup, but may
involve enabling packet forwarding (e.g., `sysctl -w net.ipv4.ip_forward=1`), modifying firewall rules (e.g. `iptables`),
and/or enabling NAT (e.g., `iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`). Refer to your host machine's network manager
documentation for more the best way to configure this for your specific setup.

### Connecting via SSH

Once you have network connectivity, you can SSH into the Jetson devkit:

```bash
ssh kepler@192.168.109.1
```

When prompted, use the password: `kepler`

> **Tip:** For passwordless SSH access, you can copy your SSH key to the Jetson:
> ```bash
> ssh-copy-id kepler@192.168.109.1
> ```

## Useful Jetson Commands

Once you've logged into your Jetson, these commands can help you monitor and debug the system.

### System Monitoring

```bash
# View real-time system telemetry (CPU/GPU usage, temperature, memory, etc.)
sudo tegrastats

# Interactive system monitoring TUI
sudo jtop
```

### Hardware Information

```bash
# Display EEPROM information
sudo tegra-eeprom-tool show
```

### Build and Version Information

```bash
# View OS release information
cat /etc/os-release

# View NVIDIA Tegra release information
cat /etc/nv_tegra_release

# View build information
cat /etc/buildinfo
```

## Customizing the Image

### Creating Custom Layers

Create a new layer for your customizations:

```bash
kas shell kas-kepler-jetson.yml -c 'bitbake-layers create-layer ../meta-custom-layer'
```

Then add the layer to your `kas` configuration file.

### Adding Custom Packages

To add additional packages to the image:

1. **Modify the image recipe** - Create a bbappend file for the image recipe:

```bash
# Create a bbappend file for the image recipe in your layer
cat > meta-custom-layer/recipes-core/images/kepler-jetson-odc-dev-base.bbappend << EOF
# Add packages to the image
CORE_IMAGE_EXTRA_INSTALL += " package1 package2 package3"
EOF
```

2. **Alternative: Create/modify a package group** - Package groups help organize related packages:

```bash
# Create a new package group recipe in your layer
cat > meta-custom-layer/recipes-core/packagegroups/packagegroup-my-extras.bb << EOF
DESCRIPTION = "Additional packages for Kepler Jetson image"
LICENSE = "MIT"

inherit packagegroup

RDEPENDS:${PN} = "\\
    package1 \\
    package2 \\
    package3 \\
"
EOF

# Then add the package group to your image recipe
echo 'CORE_IMAGE_EXTRA_INSTALL += "packagegroup-my-extras"' >> meta-custom-layer/recipes-core/images/kepler-jetson-odc-dev.bbappend
```

### Customizing the Linux Kernel

To customize the Linux kernel configuration:

1. **Generate a kernel config fragment using menuconfig and diffconfig**:

```bash
# Configure the kernel using menuconfig
kas shell kas-kepler-jetson.yml -c 'bitbake -c menuconfig virtual/kernel'

# Generate the config fragment
kas shell kas-kepler-jetson.yml -c 'bitbake -c diffconfig virtual/kernel'

# Copy the fragment to your layer
cp build/tmp/work/kepler_ecg_v1-kepler-linux/linux-jammy-nvidia-tegra/5.15.148+git/fragment.cfg meta-custom-layer/recipes-kernel/linux/linux-jammy-nvidia-tegra/my-fragment.cfg
```

2. **Modify the existing kernel recipe bbappend**:

```bash
# Modify it to include your new fragment file
echo "SRC_URI += \"file://my-fragment.cfg\"" >> meta-custom-layer/recipes-kernel/linux/linux-jammy-nvidia-tegra_%.bbappend
```

> **Note:** If you manually want to create a config fragment file, it should only contain the specific kernel options you want to modify. Each option should be on a separate line, and the format should match the kernel's `.config` file format.

## Development Tips

### Adjusting the number of cores used for a build

Add these to your `local.conf` or `kas` configuration:

```
# Adjust based on your CPU cores
BB_NUMBER_THREADS = "8"
PARALLEL_MAKE = "-j8"
```

### Using kas Shell

For a temporary bitbake environment without starting a build:

```bash
kas shell kas-kepler-jetson.yml

# You are now in a shell with the bitbake environment set up
# Run bitbake commands here, then type 'exit' when done
```

This gives you access to bitbake commands without launching a build.

### Useful Bitbake Commands

```bash
# List available recipes
kas shell kas-kepler-jetson.yml -c 'bitbake-layers show-recipes'

# Show layer dependencies
kas shell kas-kepler-jetson.yml -c 'bitbake-layers show-layers'

# Clean specific recipe
kas shell kas-kepler-jetson.yml -c 'bitbake <recipe> -c clean'

# Build specific recipe
kas shell kas-kepler-jetson.yml -c 'bitbake <recipe>'

# Enter a development shell for a given recipe
kas shell kas-kepler-jetson.yml -c 'bitbake <recipe> -c devshell'

# Show recipe dependencies
kas shell kas-kepler-jetson.yml -c 'bitbake -g <recipe> && cat pn-buildlist'
```

## Troubleshooting

### Build Issues

- **Missing dependencies**: Ensure all host dependencies are installed
- **Build failures**: Check logs in `build/tmp/log/`
- **Disk space issues**: Yocto builds require significant disk space (100GB+ recommended)
- **Cache conflicts**: Try `rm -rf build/sstate-cache` if build issues persist

### Flashing Issues

- **Device not detected**: Ensure the Jetson is in recovery mode and visible via `lsusb`
- **Flash failures**: Check the `doflash.sh` logs for specific errors
- **Permission errors**: Make sure you're using `sudo` for flashing commands

### Network Issues

- **Can't connect to Jetson**: Verify IP configuration on both host and Jetson
- **SSH failures**: Ensure SSH service is running on the Jetson (`systemctl status sshd`)
- **Slow connection**: Check for network interface errors with `dmesg` on both devices

### OTA Update Issues

- **Update fails**: Verify compatibility between current and new image versions
- **swupdate errors**: Check logs with `journalctl -u swupdate`

## References

- [meta-tegra GitHub Repository](https://github.com/OE4T/meta-tegra)
- [tegra-demo-distro GitHub Repository](https://github.com/OE4T/tegra-demo-distro)
- [Yocto Project Documentation](https://docs.yoctoproject.org/)
- [kas Documentation](https://kas.readthedocs.io/)
- [NVIDIA Jetson Linux Documentation](https://docs.nvidia.com/jetson/)
