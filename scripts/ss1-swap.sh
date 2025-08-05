#!/bin/bash

if [[ ! -f "./installer.lock" ]]; then
    source ../helper.sh
    load_path
fi

SWAPTYPE="$(yq -r '.distro.swap.mode' "$DISTRO_CONFIG")"
if [[ $SWAPTYPE == 'partition' || $SWAPTYPE == 'file' || $SWAPTYPE == 'zram' ]]; then
    FILE=$(basename "$BASH_SOURCE")

    run 'echo ""'
    run 'echo "=== Begin Distro Installer - $FILE ==="'
    run 'echo ""'

    run 'swapoff -av'
    run 'echo ""'
    if [[ ! -f "./installer.lock" ]]; then
	umount_part
	mount_part
	run 'echo ""'
	info 
    fi

    get_desc "$FILE"

    if [[ $SWAPTYPE == 'partition' ]]; then
	PART="$(yq -r '.distro.swap.partition.value' "$DISTRO_CONFIG")"
	run 'swapon -v $PART'
    else
	if [[ $SWAPTYPE == 'file' ]]; then
	    FILE="$(yq -r '.distro.swap.file.name' "$DISTRO_CONFIG")"
	    SIZE="$(yq -r '.distro.swap.file.size' "$DISTRO_CONFIG")"
	    run 'rm -v "$ROOTM/$FILE"'
	    run 'dd if=/dev/zero of=$ROOTM/$FILE bs=1M count=$SIZE status=progress'
	    run 'chmod -v 600 "$ROOTM/$FILE"'
	    run 'mkswap "$ROOTM/$FILE"'
	    run 'swapon -v "$ROOTM/$FILE"'
	else # zram
	    ALGO="$(yq -r '.distro.swap.zram.algo' "$DISTRO_CONFIG")"
	    PERC="$(yq -r '.distro.swap.zram.perc' "$DISTRO_CONFIG")"
	    SIZE="$(yq -r '.distro.swap.zram.size' "$DISTRO_CONFIG")"
	    croot 'apt install -y zram-tools'

	    cat > "$ROOTM/etc/default/zramswap"<<EOF
# Compression algorithm selection
# speed: lz4 > zstd > lzo
# compression: zstd > lzo > lz4
# This is not inclusive of all that is available in latest kernels
# See /sys/block/zram0/comp_algorithm (when zram module is loaded) to see
# what is currently set and available for your kernel[1]
# [1] https://github.com/torvalds/linux/blob/master/Documentation/blockdev/zram.txt#L86
ALGO=zstd
 
# Specifies the amount of RAM that should be used for zram
# based on a percentage the total amount of available memory
# This takes precedence and overrides SIZE below
PERCENT=50
 
# Specifies a static amount of RAM that should be used for
# the ZRAM devices, this is in MiB
SIZE=4096
 
# Specifies the priority for the swap devices, see swapon(2)
# for more details. Higher number = higher priority
# This should probably be higher than hdd/ssd swaps.
PRIORITY=100
EOF

	    run 'sed -i.bak \
    	    	-e "s/^ALGO=.*/ALGO=${ALGO}/" \
    		"$ROOTM/etc/default/zramswap"'

	    if [[ $PERC != "null" ]]; then
		run 'sed -i \
    	    	-e "s/^PERCENT=.*/PERCENT=${PERC}/" \
    		"$ROOTM/etc/default/zramswap"'
	    else # size
		run 'sed -i \
		-e "s/^PERCENT=/#PERCENT=/" \
    	    	-e "s/^SIZE=.*/SIZE=${SIZE}/" \
    		"$ROOTM/etc/default/zramswap"'
	    fi

	    run 'echo ""'
	    run 'cat "$ROOTM/etc/default/zramswap"'
	    
	fi     
    fi

    run 'echo ""'
    run 'echo "=== End Distro Installer - $FILE ==="'
    run 'echo ""'
fi
