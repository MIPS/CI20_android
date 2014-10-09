#
# Copyright 2008-2014 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This file is executed by build/envsetup.sh, and can use anything
# defined in envsetup.sh. It adds choices to the lunch menu.
#
# In particular, you can add lunch options with the add_lunch_combo
# function: add_lunch_combo generic-eng

#
# This defines a command that you can use after doing the
# the lunch command.
#
# This builds a $OUT_DIR/target/product/ci20/update.zip
# file that can be passed to the update command.
#
pack-update()
{
	# You can add 'recovery' here too, we just don't by default
	[ "x$*" = "x" ] && IMAGES="x-boot-v3nand boot recovery system recovery" || IMAGES="$*"

	[ "x$OUT_DIR" = "x" ] && OUT_DIR=out
        # FIXME: builtin path
	SRCDIR=$ANDROID_BUILD_TOP/device/imgtec/ci20

	echo "Packing $IMAGES and info into update.zip.."
	pushd $OUT_DIR/target/product/ci20 >/dev/null
		rm -f update.zip
		mkdir -p META-INF/com/google/android
		cp -fp $SRCDIR/updater-script META-INF/com/google/android/updater-script
		cp -fp system/bin/updater META-INF/com/google/android/update-binary
		zip -r -1 update.zip \
			android-info.txt \
			META-INF/com/google/android \
			`for i in $IMAGES; do echo -n "${i}.img "; done`
	popd >/dev/null
	echo "Done."

	echo -n "Signing update.zip with testkeys (this can take a while).."
	mv $OUT_DIR/target/product/ci20/update.zip \
	   $OUT_DIR/target/product/ci20/update.zip.unsigned
	java -jar ${ANDROID_HOST_OUT}/framework/signapk.jar -w \
			  build/target/product/security/testkey.x509.pem \
			  build/target/product/security/testkey.pk8 \
			  $OUT_DIR/target/product/ci20/update.zip.unsigned \
			  $OUT_DIR/target/product/ci20/update.zip
	echo "done."
}

flash-update()
{
	[ "x$OUT_DIR" = "x" ] && OUT_DIR=out
	pack-update $*
	adb usb
	sleep 4
	adb sideload $OUT_DIR/target/product/ci20/update.zip
}

add_lunch_combo aosp_ci20-userdebug
