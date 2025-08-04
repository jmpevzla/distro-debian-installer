#!/bin/bash


if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

DTYPE="$(yq -r '.distro.config.desktop.type' "$DISTRO_CONFIG")"
if [[ $DTYPE == "kde" ]]; then
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

    # Minimal desktop. kde-full and kde-standard packages depend on this package
    if [[ $DINSTALL == "minimal" ]]; then
	croot 'apt install -y kde-plasma-desktop'
    fi
	
    # Debian's selection of common KDE packages for a smaller, more flexible KDE environment compared to kde-full
    if [[ $DINSTALL == "standard" ]]; then
	croot 'apt install -y kde-standard'
    fi
    
    # The standard/upstream release. Full release of workspace, applications and framework
    if [[ $DINSTALL == "full" ]]; then
	croot 'apt install -y kde-full'
    fi
    
    # Making GNOME/GTK applications look natural
    croot 'apt install -y breeze-gtk-theme kde-config-gtk-style kde-config-gtk-style-preview'

    # Debian's selection of applications for a KDE desktop
    if [[ $DEXTRAS == "Yes" ]]; then
	croot 'apt install -y task-kde-desktop'
    fi


    run 'echo ""'
    run 'echo "=== End Distro Installer - $FILE ==="'
    run 'echo ""'
fi
