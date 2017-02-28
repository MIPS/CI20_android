#
# Copyright 2012-2014 The Android Open Source Project
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

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := $(LOCAL_PATH)/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES := \
    $(LOCAL_KERNEL):kernel

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/init.ci20.rc:root/init.ci20.rc \
    $(LOCAL_PATH)/config/init.ci20.usb.rc:root/init.ci20.usb.rc \
    $(LOCAL_PATH)/config/ueventd.ci20.rc:root/ueventd.ci20.rc \
    $(LOCAL_PATH)/config/init.recovery.ci20.rc:root/init.recovery.ci20.rc

ifeq ($(WITH_EXT4),true)
PRODUCT_COPY_FILES += $(LOCAL_PATH)/config/fstab-ext4.ci20:root/fstab.ci20
else
PRODUCT_COPY_FILES += $(LOCAL_PATH)/config/fstab.ci20:root/fstab.ci20
endif

# Input device files
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/config/gpio-keys.kl:/system/usr/keylayout/gpio-keys.kl

# Audio policy
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/config/audio_policy.conf:system/etc/audio_policy.conf

# ALSA mixer controls
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/config/mixer_paths.xml:system/etc/mixer_paths.xml

# Media Codecs
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/config/media_profiles.xml:system/etc/media_profiles.xml \
        frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
        frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:system/etc/media_codecs_google_video.xml \
	$(LOCAL_PATH)/config/media_codecs.xml:system/etc/media_codecs.xml

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
    $(LOCAL_PATH)/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:system/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml



#FIXME: set PRODUCT_AAPT_CONFIG? Eg: 
## # This device is xhdpi.  However the platform doesn't
## # currently contain all of the bitmaps at xhdpi density so
## # we do this little trick to fall back to the hdpi version
## # if the xhdpi doesn't exist.
## PRODUCT_AAPT_CONFIG := normal hdpi xhdpi xxhdpi
## PRODUCT_AAPT_PREF_CONFIG := xxhdpi

PRODUCT_CHARACTERISTICS := tablet

# Add our overlay
#
DEVICE_PACKAGE_OVERLAYS += device/imgtec/ci20/overlay

PRODUCT_PACKAGES := 	\
    mke2fs          	\
    mke2fs_host     	\
    e2fsck          	\
    e2fsck_host     	\
    setup_fs	    	\
    updater	    	\
    libnand_utils       \
    burner              \
    guidance            \
    busybox

PRODUCT_PACKAGES += 	\
    ethernet

PRODUCT_PACKAGES +=      \
    hwcomposer.xb4780    \
    audio.primary.xb4780 \
    audio_policy.xb4780  \
    lights.xb4780        \
    libdmmu              \
    libjzipu             \
    audio.a2dp.default   \
    libdrm

#
# Build libxbomx packages/modules from source:
#
PRODUCT_PACKAGES += \
    libstagefrighthw \
    libstagefright_hard_alume \
    libstagefright_hard_vlume \
    libstagefright_hard_x264hwenc \
    libOMX_Core

#
# WiFi support
#
PRODUCT_PACKAGES += \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072

PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=160

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

# for CtsVerifier
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

$(call inherit-product, hardware/ingenic/xb4780/libGPU/gpu.mk)

#
# Prebuilt WiFi drivers and firmware
#
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/wifi.iw8103/IW/bcm4330/fw_bcm4330b2.bin:system/etc/firmware/brcm/brcmfmac4330-sdio.bin \
        $(LOCAL_PATH)/wifi.iw8103/IW/bcm4330/nv_4330b2.txt:system/etc/firmware/brcm/brcmfmac4330-sdio.txt \
        $(LOCAL_PATH)/wifi.iw8103/IW/bcm4330/TestRelease_BCM4330_0243.0000_Alltek_AW70_37p4M.hcd:system/etc/firmware/bcm4330/BCM4330.hcd

# FIXME: TODO
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.timezone=America/Los_Angeles

PRODUCT_PROPERTY_OVERRIDES += \
    testing.mediascanner.skiplist=/storage/host-udisk/,/storage/udisk/

PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/config/excluded-input-devices.xml:system/etc/excluded-input-devices.xml  	        \
	$(LOCAL_PATH)/config/bt_addr:system/etc/firmware/bcm4330/bt_addr                                \
	$(LOCAL_PATH)/config/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf                         \
	$(LOCAL_PATH)/config/zram.sh:system/etc/zram.sh

# Magiccode libakim
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/akim/libakim.so:/system/vendor/lib/libakim.so \
        $(LOCAL_PATH)/akim/magiccode_prefs.xml:/data/system/magiccode_prefs.xml

#
# Copy H263/MPEG4 firmware
#
$(call inherit-product, hardware/ingenic/xb4780/libxbomx/xbomx.mk)

#
# inherit from the non-open-source side, if present
#
$(call inherit-product-if-exists, vendor/imgtec/$(TARGET_BOARD_NAME)/$(TARGET_BOARD_NAME)-vendor.mk)
$(call inherit-product-if-exists, vendor/google/products/gms.mk)

# Get the TTS language packs
$(call inherit-product-if-exists, external/svox/pico/lang/all_pico_languages.mk)

# Get some sounds
$(call inherit-product-if-exists, frameworks/base/data/sounds/AllAudio.mk)

# Get a list of small languages.
$(call inherit-product-if-exists, frameworks/base/data/fonts/fonts.mk)
$(call inherit-product-if-exists, external/cibu-fonts/fonts.mk)
$(call inherit-product-if-exists, external/lohit-fonts/fonts.mk)
$(call inherit-product-if-exists, external/naver-fonts/fonts.mk)
$(call inherit-product-if-exists, frameworks/base/data/keyboards/keyboards.mk)


PRODUCT_PROPERTY_OVERRIDES +=                                           \
    ro.debuggable=1                                                     \
    service.adb.root=1							\
    persist.service.adb.enable=1


PRODUCT_PROPERTY_OVERRIDES +=    \
    ro.telephony.call_ring.multiple=0                                   \
    mobiled.libpath=/system/lib/libmobiled.so

# FIXME: needed?
#PRODUCT_PROPERTY_OVERRIDES +=                                           \
#     ro.board.hdmi.support=true                                        \
#     ro.board.hdmi.device=HDMI,LCD,SYNC                                \
#     ro.board.hdmi.hotplug.support=true                                \

PRODUCT_PROPERTY_OVERRIDES +=                                           \
     ro.board.tvout.support=false
#    ro.board.haspppoe=pppoe

# H/W composition disabled
PRODUCT_PROPERTY_OVERRIDES +=                                          \
    debug.sf.hw=1                                                      \
    debug.gr.numframebuffers=3

PRODUCT_PROPERTY_OVERRIDES += \
        net.dns1=8.8.8.8 \
        net.dns2=8.8.4.4

# for hardware/libhardware/hardware.c "ro.product.board","ro.board.platform",
PRODUCT_POLICY := android.policy_mid

#$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4324/device-bcm.mk)
