#!/usr/bin/env bash

_run_set_raspi_config() {
  # Source: https://raspberrypi.stackexchange.com/a/66939

  # Autologin
  log "  Enable Autologin for user"
  sudo raspi-config nonint do_boot_behaviour B2

  # Wait for network at boot
  # log "  Enable 'Wait for network at boot'"
  # sudo raspi-config nonint do_boot_wait 1

  # power management of wifi: switch off to avoid disconnecting
  log "  Disable Wifi power management to avoid disconnecting"
  sudo iwconfig wlan0 power off

  # On-board audio
  if [ "$DISABLE_ONBOARD_AUDIO" == true ]; then
    local configFile=$(get_boot_config_path)
    log "  Disable on-chip BCM audio"
    if grep -q -E "^dtparam=([^,]*,)*audio=(on|true|yes|1).*" "${configFile}" ; then
      local configFile_backup="${configFile}.backup.audio_on_$(date +%d.%m.%y_%H.%M.%S)"
      log "    Backup ${configFile} --> ${configFile_backup}"
      sudo cp "${configFile}" "${configFile_backup}"
      sudo sed -i "s/^\(dtparam=\([^,]*,\)*\)audio=\(on\|true\|yes\|1\)\(.*\)/\1audio=off\4/g" "${configFile}"
    else
      log "    On board audio seems to be off already. Not touching ${configFile}"
    fi
  fi
}

_run_set_distro_config() {
  log "  Enable Autologin for user"
  #/DietPi/dietpi/login
  # sudo dietpi-autostart 0

  log "  Disable Wifi power management to avoid disconnecting"
  # iwconfig is deprecated, use iw instead
  local interface_name="wlan0"
  local service_name="disable-wifi-powersave.service"
  local service_file="/etc/systemd/system/${service_name}"
  local iw_command="/usr/sbin/iw" # Full path to iw command, important for systemd

  log "Disabling WiFi power management temporarily using iw..."
  sudo ${iw_command} dev ${interface_name} set power_save off
  if [ $? -ne 0 ]; then
    exit_on_error "Error: Failed to disable power management using iw command."
  fi
  log "WiFi power management disabled temporarily (until reboot)."

  log "Creating systemd service file: ${service_file}"
  sudo bash -c 'cat <<EOF > "${1}"
[Unit]
Description=Disable WiFi Power Management
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c "${iw_command} dev ${interface_name} set power_save off"

[Install]
WantedBy=multi-user.target
EOF' -- "${service_file}"

  if [ $? -ne 0 ]; then
    exit_on_error "Error: Failed to create systemd service file."
  fi
  log "Systemd service file created successfully."

  log "Enabling and starting systemd service..."
  sudo systemctl enable "${service_name}"
  if [ $? -ne 0 ]; then
    exit_on_error "Error: Failed to enable systemd service."
  fi
  sudo systemctl start "${service_name}"
  if [ $? -ne 0 ]; then
    exit_on_error "Error: Failed to start systemd service."
  fi
  log "Systemd service enabled and started."
}

set_distro_config() {
    SBC_PLATFORM=$(get_sbc_platform)
    log "Detected SBC platform: $SBC_PLATFORM"

    LINUX_DISTRO=$(get_distro)
    log "Detected Distribution: $LINUX_DISTRO"

    if [[ "$LINUX_DISTRO" == "Raspberry Pi OS" || "$LINUX_DISTRO" == "Raspbian (Legacy)" ]]; then
      log "Running Raspberry Pi OS/Raspbian (Legacy) specific commands ..."
      run_with_log_frame _run_set_raspi_config "Set default raspi-config"
    elif [[ "$LINUX_DISTRO" == "DietPi" ]] || [[ "$LINUX_DISTRO" == "Armbian" ]]; then
      run_with_log_frame _run_set_distro_config "Set default distro-config"
    else
      log "Distro not supported. Skipping distro specific configuration."
    fi
}


