#!/usr/bin/env bash

BUILD_LIBZMQ_WITH_DRAFTS_ON_DEVICE=${BUILD_LIBZMQ_WITH_DRAFTS_ON_DEVICE:-"false"}
ENABLE_AUTOHOTSPOT=true
AUTOHOTSPOT_PROFILE="Phoniebox_Hotspot"
AUTOHOTSPOT_SSID="$AUTOHOTSPOT_PROFILE"
AUTOHOTSPOT_PASSWORD="PlayItLoud!"
AUTOHOTSPOT_IP="10.0.0.1"
AUTOHOTSPOT_COUNTRYCODE="DE"

# DISABLE Services
DISABLE_SSH_QOS=false
DISABLE_BOOT_SCREEN=true
DISABLE_BOOT_LOGS_PRINT=true
DISABLE_BLUETOOTH=false
ENABLE_STATIC_IP=false
DISABLE_IPv6=true
DISABLE_DISTRO_CONFIG=false
DISABLE_KEYBOARD_SETUP=false
DISABLE_TRIGGERHAPPY=true
DISABLE_APT_DAILY=false

SETUP_MPD=true
ENABLE_MPD_OVERWRITE_INSTALL=true
UPDATE_DISTRO=${UPDATE_DISTRO:-"false"}
ENABLE_RFID_READER=true
ENABLE_SAMBA=true
SAMBA_PASSWORD="PlayItLoud!"
ENABLE_WEBAPP=true
ENABLE_KIOSK_MODE=true
DISABLE_ONBOARD_AUDIO=false
# Always try to use GIT with SSH first, and on failure drop down to HTTPS
GIT_USE_SSH=${GIT_USE_SSH:-"true"}

# A pre-build binary for the Web App is only available for release builds
# For non-production builds, the Wep App must be build locally
# Valid values
# - release-only: download in release branch only
# - true: force download even in non-release branch
# - false: never download
ENABLE_WEBAPP_PROD_DOWNLOAD=${ENABLE_WEBAPP_PROD_DOWNLOAD:-"release-only"}
