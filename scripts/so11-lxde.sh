#!/bin/bash


if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

DTYPE="$(yq -r '.distro.config.desktop.type' "$DISTRO_CONFIG")"
if [[ $DTYPE == "lxde" ]]; then
    
    FILE=$(basename "$BASH_SOURCE")

    run 'echo ""'
    run 'echo "=== Begin Distro Installer - $FILE ==="'
    run 'echo ""'

    if [[ ! -f "./installer.lock" ]]; then
	load_single
    fi

    get_desc "$FILE"
    apt_update


    DINSTALL="$(yq -r '.distro.config.desktop.install' "$DISTRO_CONFIG")"
    DEXTRAS="$(yq -r '.distro.config.desktop.extras' "$DISTRO_CONFIG")"

    # core LXDE desktop
    if [[ $DINSTALL == "minimal" ]]; then
	croot 'apt install -y lxde-core'
    fi
    
    # full LXDE desktop
    if [[ $DINSTALL == "standard" ]]; then
	croot 'apt install -y lxde'
    fi
    
    # complete Debian LXDE desktop
    if [[ $DINSTALL == "full" ]]; then
	croot 'apt install -y task-lxde-desktop'
    fi

    # extras packages
    if [[ $DEXTRAS == "Yes" ]]; then
	croot 'apt install -y firefox-esr gimp vlc libreoffice synaptic'
    fi

    run 'echo ""'
    run 'echo "=== End Distro Installer - $FILE ==="'
    run 'echo ""'
fi
