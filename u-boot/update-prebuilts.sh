#!/bin/bash
#
# Copyright (c) 2013,2014,2017 Imagination Technologies
# Original-Author: Paul Burton <paul.burton@imgtec.com>
#
# Creates
# Derived from the Debian setup script by Paul Burton
#
# Usage:
#	./update-prebuilts.sh [--repo=<repository-path>] [--branch=<repository-branch>]
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
		--repo=*)
			UBOOT_REPO=$OPTARG
			;;
		--branch=*)
			UBOOT_BRANCH=$OPTARG
			;;
		--help|-?)
			echo "Usage : update-prebuilts.sh [--repo=<repository-path>] [--branch=<repository-branch>]"
			exit 0
			;;
		*)
			echo "Unrecognized option ${OPT}"
			echo "Type --help or -? for usage information."
			die
			;;
	esac
done

# default environment
[ ! -z "${CROSS_COMPILE}" ] || export CROSS_COMPILE=mips-linux-gnu-
[ ! -z "${UBOOT_REPO}" ] || UBOOT_REPO="https://github.com/MIPS/CI20_u-boot"
[ ! -z "${UBOOT_BRANCH}" ] || UBOOT_BRANCH="android-ci20-v2013.10"

# check for tools
which bc >/dev/null || die "No bc in \$PATH"
${CROSS_COMPILE}gcc --version >/dev/null 2>&1 || \
	die "No ${CROSS_COMPILE}gcc, set \$CROSS_COMPILE"
${CROSS_COMPILE}objcopy --version >/dev/null 2>&1 || \
	die "No ${CROSS_COMPILE}objcopy, set \$CROSS_COMPILE"

if [ -z "${JOBS}" ]; then
	cpuCount=`grep -Ec '^processor' /proc/cpuinfo`
	JOBS=`echo "${cpuCount} * 2" | bc`
fi

# initialize ubootPrebuiltDir with the script's location
pushd `dirname $0` &> /dev/null
ubootPrebuiltDir=`pwd`
popd &> /dev/null

# clone u-boot
ubootDir=$tmpDir/u-boot
git clone ${UBOOT_REPO} -b ${UBOOT_BRANCH} --depth 1 $ubootDir

# build & copy MMC u-boot
# mkenvimage is the same for both builds and copied once for both flavors
pushd $ubootDir
	make distclean
	make ci20_mmc_config
	make -j${JOBS}
	cp spl/u-boot-spl.bin ${ubootPrebuiltDir}/mmc/
	cp u-boot.img ${ubootPrebuiltDir}/mmc/
	cp tools/mkenvimage ${ubootPrebuiltDir}/mkenvimage
popd

# build & copy NAND u-boot
pushd $ubootDir
	make distclean
	make ci20_config
	make -j${JOBS}
	cp spl/u-boot-spl.bin ${ubootPrebuiltDir}/nand/
	cp u-boot.img ${ubootPrebuiltDir}/nand/
popd

echo -e "\nSuccesfully built U-Boot"
echo -e "\trepository: \t$UBOOT_REPO"
echo -e "\tbranch: \t$UBOOT_BRANCH"
