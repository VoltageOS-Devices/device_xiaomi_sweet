LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := RemovePackages
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_OVERRIDES_PACKAGES := LiveWallpapersPicker arcore DiagnosticsToolPrebuilt PixelWallpapers2021 Photos talkback AndroidAutoStubPrebuilt PixelLiveWallpaperPrebuilt RecorderPrebuilt SafetyHubPrebuilt TipsPrebuilt
LOCAL_UNINSTALLABLE_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := /dev/null
include $(BUILD_PREBUILT)
