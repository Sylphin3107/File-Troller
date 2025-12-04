#!/bin/bash
set -e

# ---------------------------------------------
# CLEAN BUILD FOLDER
# ---------------------------------------------
rm -rf build || true

# ---------------------------------------------
# XCODEBUILD (no signing)
# ---------------------------------------------
xcodebuild \
  -project FileTroller.xcodeproj \
  -scheme patchlq \
  -configuration Release \
  -sdk iphoneos \
  BUILD_DIR="build/" \
  CODE_SIGNING_ALLOWED="NO" \
  CODE_SIGNING_REQUIRED="NO" \
  CODE_SIGN_IDENTITY=""

# ---------------------------------------------
# FIND build/Release-iphoneos FOLDER (Xcode 14–16)
# ---------------------------------------------
if [ -d "build/Release-iphoneos" ]; then
  OUT="build/Release-iphoneos"
elif [ -d "build/Build/Products/Release-iphoneos" ]; then
  OUT="build/Build/Products/Release-iphoneos"
else
  echo "❌ ERROR: Could not find Release-iphoneos folder!"
  exit 1
fi

cd "$OUT"

APP="patchlq.app"
BIN="$APP/patchlq"

# ---------------------------------------------
# SIGN BINARY
# ---------------------------------------------
ldid -S../../ent.xml "$BIN" -Icom.34306.patchlq

# ---------------------------------------------
# APPLY CT_BYPASS
# ---------------------------------------------
chmod +x ../../macbins/ct_bypass
../../macbins/ct_bypass -i "$BIN" -o "$BIN" -r

# ---------------------------------------------
# ADD TOOLS
# ---------------------------------------------
cp ../../bins/insert_dylib "$APP"/
cp ../../bins/unzip "$APP"/

# ---------------------------------------------
# COPY DYLIBS
# ---------------------------------------------
mkdir -p "$APP/dylibs"
cp ../../dylibs/*.zip "$APP/dylibs"/

# ---------------------------------------------
# PACKAGE TIPA
# ---------------------------------------------
rm -rf Payload || true
mkdir Payload
cp -r "$APP" Payload/

zip -r patchlq.tipa Payload

# NO "open ." – GitHub runner has no GUI
# ---------------------------------------------

echo "---------------------------------------------"
echo "✔ Build completed!"
echo "✔ Output: $OUT/patchlq.tipa"
echo "---------------------------------------------"
