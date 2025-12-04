#!/bin/bash
set -e
rm -rf build | true

xcodebuild BUILD_DIR="build/" CODE_SIGNING_ALLOWED="NO" CODE_SIGNING_REQUIRED="NO" CODE_SIGN_IDENTITY=""
cd dylibs
#./load_cmd.sh
cd ..
cd build/Release-iphoneos/
ldid -S../../ent.xml patchlq.app/patchlq -Icom.34306.patchlq
../../macbins/ct_bypass -i patchlq.app/patchlq -o patchlq.app/patchlq -r
#cp ../../bins/ct_bypass patchlq.app/
cp ../../bins/insert_dylib patchlq.app/
cp ../../bins/unzip patchlq.app/
mkdir patchlq.app/dylibs
cp ../../dylibs/*.zip patchlq.app/dylibs/
mkdir Payload
cp -r patchlq.app Payload/
zip -r patchlq.tipa Payload
open .
cd ../../
