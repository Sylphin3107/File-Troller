#!/bin/bash

set -e

rm *.zip | true
rm dylibs/load.dylib | true
#cp modding/load.dylib dylibs/load.dylib

# add the dylibs

# optool install -p @executable_path/Frameworks/iSponsorBlock.dylib -t dylibs/load.dylib
# optool install -p @executable_path/Frameworks/YouTubeDislikesReturn.dylib -t dylibs/load.dylib
# optool install -p @executable_path/Frameworks/YouTubeX.dylib -t dylibs/load.dylib
# optool install -p @executable_path/Frameworks/YTABConfig.dylib -t dylibs/load.dylib
# optool install -p @executable_path/Frameworks/YTClassicVideoQuality.dylib -t dylibs/load.dylib
# optool install -p @executable_path/Frameworks/YTUHD.dylib -t dylibs/load.dylib
#insert_dylib @executable_path/Frameworks/iSponsorBlock.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/YouTubeDislikesReturn.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/YouTubeX.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/YTABConfig.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/YTClassicVideoQuality.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/YTUHD.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/DontEatMyContent.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/NoYTPremium.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/YTShortsProgress.dylib dylibs/load.dylib --inplace --overwrite --all-yes
#insert_dylib @executable_path/Frameworks/CarBridge.dylib dylibs/load.dylib --inplace --overwrite --all-yes

# sign the empty dylib

#ldid -S dylibs/load.dylib
#~/building/ChOma/output/tests/ct_bypass -i dylibs/load.dylib -o dylibs/load.dylib -t EQHXZ8M8AV -r
#chmod -x dylibs/load.dylib

# zip all of it up
#
#cd RYD
#zip -r RYD.zip *.bundle
#mv RYD.zip ../
#cd ../
# cd dylibs
# zip -r dylibs.zip *.dylib CydiaSubstrate.framework
# mv dylibs.zip ../
# cd ../
zip -r dylibs.zip AWSCognito