#!/bin/bash
# NetHunter kernel for Samsung Galaxy Note 5 build script by jcadduono
# This build script is for TouchWiz with Kali Nethunter support only
# This build script builds all variants in ./VARIANTS
#
###################### CONFIG ######################

# root directory of NetHunter noblelte git repo (default is this script's location)
RDIR=$(pwd)

# output directory of zImage and dtb.img
OUT_DIR=/home/jc/build/kali-nethunter/nethunter-installer/kernels/lollipop

############## SCARY NO-TOUCHY STUFF ###############

KDIR=$RDIR/arch/arm64/boot

MOVE_IMAGES()
{
	echo "Moving Image.gz to $VARIANT_DIR/zImage..."
	rm -rf $VARIANT_DIR
	mkdir $VARIANT_DIR
	mv $KDIR/Image.gz $VARIANT_DIR/zImage
}

mkdir -p $OUT_DIR

[ "$@" ] && {
	VARIANTS=$@
} || {
	VARIANTS=$(cat $RDIR/VARIANTS)
}

for V in $VARIANTS
do
	[ "$V" == "eur" ] && {
		VARIANT_DIR=$OUT_DIR/noblelte
	} || {
		VARIANT_DIR=$OUT_DIR/noblelte$V
	}
	$RDIR/build.sh $V && MOVE_IMAGES
done

echo "Finished building NetHunter kernels!"
