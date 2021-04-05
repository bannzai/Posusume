#! /bin/bash 
set -eu
set -o pipefail

xcodebuild \
  'ENABLE_BITCODE=YES' \
  'BITCODE_GENERATION_MODE=bitcode' \
  'OTHER_CFLAGS=-fembed-bitcode' \
  'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
  'SKIP_INSTALL=NO' \
  archive \
  -project 'Umbrella.xcodeproj' \
  -scheme 'Umbrella' \
  -destination 'generic/platform=iOS Simulator' \
  -configuration 'Release' \
  -archivePath 'build/Umbrella-iOS.xcarchive'

xcodebuild \
  -create-xcframework \
  -framework 'build/Umbrella-iOS.xcarchive/Products/Library/Frameworks/Umbrella.framework' \
  -output 'build/Umbrella.xcframework'

