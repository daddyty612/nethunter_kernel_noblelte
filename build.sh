#!/bin/bash
# NetHunter kernel for Samsung Galaxy Note 5 build script by jcadduono
# This build script is for TouchWiz with Kali Nethunter support only

################### BEFORE STARTING ################
#
# download a working toolchain and extract it somewhere and configure this
# file to point to the toolchain's root directory.
#
# once you've set up the config section how you like it, you can simply run
# ./build.sh [VARIANT]
#
##################### VARIANTS #####################
#
# spr = nobleltespr (Sprint)
#       SM-N920P
#
# can = nobleltecan (Canada)
#       SM-N920W8
#
###################### CONFIG ######################

# root directory of NetHunter noblelte git repo (default is this script's location)
RDIR=$(pwd)

[ $VER ] || \
# version number
VER=$(cat $RDIR/VERSION)

# directory containing cross-compile arm-cortex_a15 toolchain
TOOLCHAIN=$HOME/build/toolchain/android-arm64-4.9

# amount of cpu threads to use in kernel make process
THREADS=5

############## SCARY NO-TOUCHY STUFF ###############

[ "$1" ] && {
	VARIANT=$1
} || {
	VARIANT=spr
}

[ -f "$RDIR/arch/arm64/configs/nethunter_noblelte${VARIANT}_defconfig" ] || {
	echo "Device variant/carrier $VARIANT not found in arm configs!"
	exit 1
}

export ARCH=arm64
export CROSS_COMPILE=$TOOLCHAIN/bin/aarch64-linux-android-
export LOCALVERSION=$VARIANT-$VER

KDIR=$RDIR/arch/$ARCH/boot

CLEAN_BUILD()
{
	echo "Cleaning build..."
	cd $RDIR
	git clean -xdf
}

BUILD_KERNEL()
{
	echo "Creating kernel config..."
	cd $RDIR
	make -C $RDIR nethunter_noblelte${VARIANT}_defconfig
	echo "Starting build for $VARIANT..."
	make -C $RDIR -j"$THREADS"
}

CLEAN_BUILD && BUILD_KERNEL && echo "Finished building $VARIANT!"
