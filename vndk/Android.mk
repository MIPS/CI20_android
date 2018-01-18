LOCAL_PATH := $(call my-dir)

ifndef BOARD_VNDK_VERSION
VNDK_SP_LIBRARIES := \
	android.hardware.graphics.mapper@2.0 \
	android.hardware.graphics.common@1.0 \
	android.hardware.graphics.allocator@2.0 \
	libcutils \
	libc++ \
	libhardware \
	libutils \
	libbacktrace \
	libbase \
	libhidlbase \
	libhidltransport \
	libhwbinder \
	libunwind \
	liblzma

endif

EXTRA_VENDOR_LIBRARIES := \
	libcrypto \
	libunwind \
	liblzma

define define-vndk-lib
include $$(CLEAR_VARS)
LOCAL_MODULE := $1.$2
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_PREBUILT_MODULE_FILE := $$(TARGET_OUT)/lib/$1.so
LOCAL_STRIP_MODULE := false
LOCAL_MULTILIB := 32
LOCAL_MODULE_TAGS := optional
LOCAL_INSTALLED_MODULE_STEM := $1.so
LOCAL_MODULE_SUFFIX := .so
LOCAL_MODULE_RELATIVE_PATH := $3
LOCAL_VENDOR_MODULE := $4
include $$(BUILD_PREBUILT)
endef

$(foreach lib,$(VNDK_SP_LIBRARIES),\
    $(eval $(call define-vndk-lib,$(lib),vndk-sp-gen,vndk-sp,)))

$(foreach lib,$(EXTRA_VENDOR_LIBRARIES),\
    $(eval $(call define-vndk-lib,$(lib),vndk-ext-gen,,true)))
