LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= AudioPolicyManager.cpp
LOCAL_SHARED_LIBRARIES:= libc libcutils libutils liblog libmedia
LOCAL_STATIC_LIBRARIES := libmedia_helper
LOCAL_WHOLE_STATIC_LIBRARIES:= libaudiopolicy_legacy
LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE:= audio_policy.ci20
LOCAL_MODULE_TAGS := eng debug
LOCAL_CFLAGS += -DWITH_A2DP

include $(BUILD_SHARED_LIBRARY)

