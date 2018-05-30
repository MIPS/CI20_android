#!/bin/bash
#
# Copyright (c) 2017 Mips Tech LLC
# Author: Dragan Cecavac <dragan.cecavac@mips.com>
#
# Usage:
#	./build-dtb.sh --kernel_dir=<kernel-src-dir-path>
#

set -e
tmpDir=`mktemp -d`

cleanup()
{
	rm -rf ${tmpDir}
	trap - EXIT INT TERM
}
trap cleanup EXIT INT TERM

die()
{
	echo "$@" >&2
	exit 1
}

for OPT; do
	OPTARG=$(expr "x$OPT" : "x[^=]*=\\(.*\\)" || true)
	case $OPT in
		--kernel_dir=*)
			KERNEL_DIR=$OPTARG
			;;
		--help|-?)
			echo "Usage : build-dtb.sh --kernel_dir=<kernel-src-dir-path>"
			exit 0
			;;
		*)
			echo "Unrecognized option ${OPT}"
			echo "Type --help or -? for usage information."
			die
			;;
	esac
done

[ ! -z "${KERNEL_DIR}" ] || die "Please specify kernel source location using option --kernel_dir="
[ ! -d "${KERNEL_DIR}" ] && die "Specified kernel source directory does not exist"

# Check for cpp
[ -z `which cpp 2>&1` ] && die "No 'cpp' present"

# Check for dtc
[ -z `which dtc 2>&1` ] && die "No 'dtc' present"

# initialize dtsPrebuiltDir with the script's location
pushd `dirname $0` &> /dev/null
dtsPrebuiltDir=`pwd`
popd &> /dev/null

cp $KERNEL_DIR/arch/mips/boot/dts/ingenic/jz4780.dtsi $tmpDir/

dts_id=("sdcard" "nand")

for i in "${dts_id[@]}"
do
	ID=ci20-$i
	SRC=$tmpDir/$ID.dts
	TMP=$tmpDir/$ID.tmp.dts
	DST=$dtsPrebuiltDir/$ID.dtb

	# Append kernel device tree source with device tree specified in Android device project
	cat $KERNEL_DIR/arch/mips/boot/dts/ingenic/ci20.dts $dtsPrebuiltDir/src/$ID.dts > $SRC

	cpp -nostdinc -I $KERNEL_DIR/include -undef -x assembler-with-cpp $SRC > $TMP
	dtc -O dtb -b 0 -o $DST $TMP
done
