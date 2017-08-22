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

USE_CUSTOM_AUDIO_POLICY := 1
USE_XML_AUDIO_POLICY_CONF := 1

# Audio policy
PRODUCT_COPY_FILES += \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:system/etc/a2dp_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:system/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:system/etc/default_volume_tables.xml \
	$(LOCAL_PATH)/config/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
	$(LOCAL_PATH)/config/audio_policy_volumes_drc.xml:system/etc/audio_policy_volumes_drc.xml \

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
    mkfs.f2fs       	\
    fsck.f2fs       	\
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
    audio_policy.default  \
    lights.xb4780        \
    libdmmu              \
    libjzipu             \
    audio.a2dp.default   \
    libdrm

# Audio HAL
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio.effect@2.0-impl

# Bluetooth HAL
PRODUCT_PACKAGES += \
    libbt-vendor \
    android.hardware.bluetooth@1.0-impl

# Camera HAL
PRODUCT_PACKAGES += \
    camera.xb4780 \
    android.hardware.camera.provider@2.4-impl

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl

# Light HAL
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    android.hardware.light@2.0-impl

 # Memtrack HAL
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl

# Power HAL
PRODUCT_PACKAGES += \
    android.hardware.power@1.0-impl \
    power.xb4780

PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.mapper@2.0-impl

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/manifest.xml:system/vendor/manifest.xml

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
    android.hardware.wifi@1.0-service \
    wpa_supplicant \
    wpa_supplicant.conf \
    wificond

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

$(call inherit-product, frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk)
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
	$(LOCAL_PATH)/config/bt_vendor.conf:system/etc/bluetooth/bt_vendor.conf

# Magiccode libakim
PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/akim/libakim.so:/system/vendor/lib/libakim.so \
        $(LOCAL_PATH)/akim/magiccode_prefs.xml:/system/etc/magiccode_prefs.xml

#
# Copy H263/MPEG4 firmware
#
$(call inherit-product, hardware/ingenic/xb4780/libxbomx/xbomx.mk)

#
# inherit from the non-open-source side, if present
#
$(call inherit-product-if-exists, vendor/imgtec/$(TARGET_BOARD_NAME)/$(TARGET_BOARD_NAME)-vendor.mk)

# configure gms
ifeq ($(WITH_GMS),true)
 $(call inherit-product-if-exists, vendor/google/products/gms.mk)
PRODUCT_COPY_FILES += \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libAppDataSearch.so:/system/priv-app/GmsCore/lib/arm/libAppDataSearch.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libconscrypt_gmscore_jni.so:/system/priv-app/GmsCore/lib/arm/libconscrypt_gmscore_jni.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libgcastv2_base.so:/system/priv-app/GmsCore/lib/arm/libgcastv2_base.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libgcastv2_support.so:/system/priv-app/GmsCore/lib/arm/libgcastv2_support.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libgmscore.so:/system/priv-app/GmsCore/lib/arm/libgmscore.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libgoogle-ocrclient-v3.so:/system/priv-app/GmsCore/lib/arm/libgoogle-ocrclient-v3.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libjgcastservice.so:/system/priv-app/GmsCore/lib/arm/libjgcastservice.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libleveldbjni.so:/system/priv-app/GmsCore/lib/arm/libleveldbjni.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libNearbyApp.so:/system/priv-app/GmsCore/lib/arm/libNearbyApp.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libsslwrapper_jni.so:/system/priv-app/GmsCore/lib/arm/libsslwrapper_jni.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libwearable-selector.so:/system/priv-app/GmsCore/lib/arm/libwearable-selector.so \
	vendor/google/apps/GmsCore/lib/armeabi-v7a/libWhisper.so:/system/priv-app/GmsCore/lib/arm/libWhisper.so
endif

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

# add chromium browser
PRODUCT_PACKAGES +=     \
    ChromePublic

#$(call inherit-product-if-exists, hardware/broadcom/wlan/bcmdhd/firmware/bcm4324/device-bcm.mk)
