# Copyright 2010-2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# This file sets variables that control the way modules are built
# thorughout the system. It should not be used to conditionally
# disable makefiles (the proper mechanism to control what gets
# included in a build is to use PRODUCT_PACKAGES in a product
# definition file).
#

# BoardConfig.mk
#
# Product-specific compile-time definitions.
#

USE_LEGACY_AUDIO_POLICY := 1

TARGET_CPU_ABI := mips
TARGET_CPU_ABI2 := armeabi-v7a
TARGET_CPU_ABI_LIST_32_BIT := mips,armeabi,armeabi-v7a
TARGET_CPU_ABI_LIST := mips,armeabi,armeabi-v7a
TARGET_CPU_SMP := true
TARGET_ARCH := mips
TARGET_ARCH_VARIANT := mips32r2-fp-xburst
TARGET_CPU_VARIANT :=

ENABLE_CPUSETS := true

ARCH_MIPS_PAGE_SHIFT := 12

TARGET_NO_BOOTLOADER := true

BOARD_KERNEL_BASE := 0x81F00000
BOARD_KERNEL_CMDLINE := mem=256M@0x0 mem=768M@0x30000000 console=ttyS0,115200 ip=off rw rdinit=/init androidboot.hardware=ci20
ifneq ($(WITH_EXT4),true)
BOARD_KERNEL_CMDLINE += ubi.mtd=4
endif

BOARD_MKBOOTIMG_ARGS := --kernel_offset 0

BOARD_HAL_STATIC_LIBRARIES := libhealthd.ci20

# Wi-Fi hardware selection
BOARD_WIFI_HARDWARE := IW8103
PRODUCT_DEFAULT_WIFI_CHANNELS := 13

ifeq ($(strip $(BOARD_WIFI_HARDWARE)), IW8103)
BOARD_HAVE_BLUETOOTH        := true
BOARD_HAVE_BLUETOOTH_BCM    := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/imgtec/ci20/bluetooth
BOARD_BT_MODULE             := BCM4330
BT_BCM4330                  := true

WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WLAN_DEVICE           := bcmdhd
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
endif

TARGET_NO_RADIOIMAGE := true
TARGET_BOARD_PLATFORM := xb4780
TARGET_BOOTLOADER_BOARD_NAME := ci20
TARGET_BOARD_INFO_FILE := device/imgtec/ci20/board-info.txt

USE_OPENGL_RENDERER := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1048576000
BOARD_FLASH_BLOCK_SIZE := 131072 # FIXME

TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_RECOVERY_UI_LIB := librecovery_ui_ci20
TARGET_RECOVERY_FSTAB = device/imgtec/ci20/config/fstab.ci20

# FIXME:
# Do the rest of these belong here?
TARGET_BOARD_PLATFORM_GPU := SGX540

TARGET_NO_KERNEL := false

# Set /system/bin/sh to mksh, not ash, to test the transition.
TARGET_SHELL := mksh

PRODUCT_VENDOR_KERNEL_HEADERS := hardware/ingenic/xb4780/kernel-headers


TARGET_WITH_MC := true

WITH_JIT := true
WITH_DEXPREOPT=true

#  Triple framebuffers for "surfaceflinger/DisplayHardware/FramebufferSurface.cpp"
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# Camera Configuration:
#   NOTE:
#     While bringing up camera it's handy to use:
#	adb shell pm enable com.android.camera2/com.android.camera.CameraLauncher
#     or
#	adb shell pm enable com.google.android.GoogleCamera/com.android.camera.CameraLauncher
#     to enable the apt.
#
BOARD_HAS_CAMERA := true
CAMERA_SUPPORT_VIDEOSNAPSHORT := false
COVERT_WITH_SOFT := false
CAMERA_VERSION := 1
CI20_AUDIO := true

# HDMI Configure
BOARD_HAS_HDMI := true
BOARD_HDMI_INFO := xb4780 3d_tx_phy

BOARD_SEPOLICY_DIRS += \
	device/imgtec/ci20/sepolicy
