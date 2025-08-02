#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
TARGET_SUPPORTS_OMX_SERVICE := false

# Inherit from sweet device
$(call inherit-product, device/xiaomi/sweet/device.mk)

# Voltage OS CPU Flag
VOLTAGE_CPU_SMALL_CORES := 0,1,2,3,4,5
VOLTAGE_CPU_BIG_CORES := 6,7

# CPU Sets configuration
VOLTAGE_CPU_BG := 0-3
VOLTAGE_CPU_FG := 0-7
VOLTAGE_CPU_LIMIT_BG := 0-2
VOLTAGE_CPU_UNLIMIT_UI := 0-7
VOLTAGE_CPU_LIMIT_UI := 0-5
VOLTAGE_CPU_DISPLAY := 6-7
VOLTAGE_CPU_AUDIO := 0-4

# Inherit common Voltage OS  Stuff.
$(call inherit-product, vendor/voltage/config/common_full_phone.mk)
TARGET_BOOT_ANIMATION_RES := 1920
PRODUCT_NAME := voltage_sweet
PRODUCT_DEVICE := sweet
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Redmi Note 10 Pro
PRODUCT_MANUFACTURER := Xiaomi
VOLTAGE_BUILD_TYPE := OFFICIAL
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc=$(call normalize-path-list, "sweet_global-user 13 TKQ1.221013.002 V14.0.8.0.TKFMIXM-release-keys")

BUILD_FINGERPRINT := Redmi/sweet_global/sweet:13/RKQ1.210614.002/V14.0.8.0.TKFMIXM:user/release-keys
