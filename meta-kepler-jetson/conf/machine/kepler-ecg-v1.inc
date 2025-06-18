# Common configuration between ECGv1 images

# To match the partition sizes used by the L4T BSP based image
EMMC_SIZE ?= "63652757504"
ROOTFSPART_SIZE_DEFAULT ?= "57982058496"

# Disabled MB1 logging for faster boot
TEGRA_FLASHVAR_MISC_CONFIG ?= "tegra234-mb1-bct-misc-kepler-ecg-v1.dts"

# Disabled carrier board EEPROM
TEGRA_FLASHVAR_MB2BCT_CFG ?= "tegra234-mb2-bct-misc-kepler-ecg-v1.dts"

# Removed audio codec from dynamic overlay
TEGRA_PLUGIN_MANAGER_OVERLAYS ?= "tegra234-kepler-ecg-v1-dynamic.dtbo tegra234-carveouts.dtbo tegra-optee.dtbo"

# Pinmux configuration for ECGv1
TEGRA_FLASHVAR_PINMUX_CONFIG ?= "tegra234-mb1-bct-pinmux-kepler-ecg-v1.dtsi"
TEGRA_FLASHVAR_PMC_CONFIG ?= "tegra234-mb1-bct-padvoltage-default-kepler-ecg-v1.dtsi"

# Kernel device tree for ECGv1
KERNEL_DEVICETREE ?= "tegra234-kepler-ecg-v1.dtb"

# Platform name to match in UEFI bootloader during OTA updates
TNSPEC_MACHINE = "jetson-agx-orin-devkit"
