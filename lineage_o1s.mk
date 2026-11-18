#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from o1s device
$(call inherit-product, device/samsung/o1s/device.mk)

# Inherit from common lineage configuration
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Google apps: Miku-Picked UI adds MindTheGapps itself when building with
# MIKU_GAPPS=true (vendor/miku/config/versioning.mk), so the tree must not
# inherit vendor/gapps here; Miku always syncs vendor/gapps and this would
# otherwise put Google apps into every build. Only the o1s allowlists for
# Play-updated Google apps are added to GApps builds.
ifeq ($(MIKU_GAPPS),true)
# Privileged permissions that Play-updated GmsCore needs but MindTheGapps'
# allowlist lacks (see configs/permissions/privapp-permissions-gms-extra.xml).
PRODUCT_PACKAGES += privapp-permissions-gms-extra.xml
# The privileged permissions Pixel's allowlist grants to the other MTG-sourced
# Google apps, so their Play updates get them too
# (configs/permissions/privapp-permissions-google-pixel-extra*.xml).
PRODUCT_PACKAGES += \
    privapp-permissions-google-pixel-extra.xml \
    privapp-permissions-google-pixel-extra-system-ext.xml
endif

PRODUCT_NAME := lineage_o1s
PRODUCT_DEVICE := o1s
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-G991B
PRODUCT_MANUFACTURER := samsung

PRODUCT_GMS_CLIENTID_BASE := android-samsung

# Use the latest approved GMS identifiers
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="o1sxxx-user 15 AP3A.240905.015.A2 G991BXXSJHZA6 release-keys" \
    BuildFingerprint=samsung/o1sxxx/o1s:11/RP1A.200720.012/G991BXXSJHZA6:user/release-keys \
    DeviceProduct=o1sxxx \
    SystemName=o1sxxx

# Define PDA property for camera
PRODUCT_SYSTEM_PROPERTIES += \
    ro.build.PDA=G991BXXSJHZA6
