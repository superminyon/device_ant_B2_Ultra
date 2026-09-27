#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from B2_Ultra device
$(call inherit-product, device/ant/B2_Ultra/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_DEVICE := B2_Ultra
PRODUCT_NAME := lineage_B2_Ultra
PRODUCT_BRAND := IIIF150
PRODUCT_MODEL := B2 Ultra
PRODUCT_MANUFACTURER := ant

PRODUCT_GMS_CLIENTID_BASE := android-ragentek

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="sys_mssi_64_cn_armv82-user 15 AP3A.240905.015.A2 1772444757 release-keys" \
    BuildFingerprint=IIIF150/B2_Ultra_eea/B2_Ultra:15/AP3A.240905.015.A2/1772444757:user/release-keys
