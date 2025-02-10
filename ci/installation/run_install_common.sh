#!/usr/bin/env bash

# Install Phoniebox and test it
# Used e.g. for tests on Docker

# Objective:
# Test for a common installation path. Including autohotspot

SOURCE="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(dirname "$SOURCE")"
LOCAL_INSTALL_SCRIPT_PATH="${INSTALL_SCRIPT_PATH:-${SCRIPT_DIR}/../../installation}"
LOCAL_INSTALL_SCRIPT_PATH="${LOCAL_INSTALL_SCRIPT_PATH%/}"

export ENABLE_WEBAPP_PROD_DOWNLOAD=true
# Run installation (in interactive mode)
# y - start setup
# y - deactivate ipv6
# n - use static ip
# y - setup autohotspot
# n -   change default configuration
# n - deactivate bluetooth
# n - disable on-chip audio
# - - mpd overwrite config (only with existing installation)
# y - setup rfid reader
# y - setup samba
# y - setup webapp
# n - build webapp (skipped due to forced webapp Download)
# y - setup kiosk mode
# n - reboot

"${LOCAL_INSTALL_SCRIPT_PATH}/install-jukebox.sh" <<< 'y
y
n
y
n
n
n
y
y
y
n
y
n
'
