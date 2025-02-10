#!/usr/bin/env bash

_run_update_distro_via_apt() {
    sudo apt-get -qq -y update && sudo apt-get -qq -y full-upgrade || exit_on_error "Failed to update distro via apt"
    if [ "$CI_RUNNING" != "true" ]; then
        sudo apt-get -qq -y autoremove
    fi
}
_run_update_dietpi() {
    sudo dietpi-update 1
}

update_distro() {
    if [ "$UPDATE_DISTRO" == true ] ; then
        detected_distro=$(get_distro)
        if [[ "$detected_distro" == "Raspberry Pi OS" || "$detected_distro" == "Raspbian (Legacy)" || "$detected_distro" == "Armbian" ]]; then
            run_with_log_frame _run_update_distro_via_apt "Updating $detected_distro"
        elif [[ "$detected_distro" == "DietPi" ]]; then
            run_with_log_frame _run_update_dietpi "Updating $detected_distro"
        else
            log "Distro not supported. Skipping distro update."
        fi
    fi
}
