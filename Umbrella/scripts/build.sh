#!/bin/sh

# Reference: https://blog.kishikawakatsumi.com/entry/2019/06/17/090724

set -eu
set -o pipefail

PWD=`dirname $0`
PROJECT_ROOT=$(cd $PWD; cd ..; pwd -P)
PODS_ROOT="$PROJECT_ROOT/Pods"
PODS_PROJECT="$PODS_ROOT/Pods.xcodeproj"
SYMROOT="$PODS_ROOT/Build"

cd "$PROJECT_ROOT"
bundle exec pod install

xcodebuild -project "$PODS_PROJECT" \
  -sdk iphoneos -configuration Release -alltargets \
  ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=NO SYMROOT="$SYMROOT" \
  CLANG_ENABLE_MODULE_DEBUGGING=NO \
  BITCODE_GENERATION_MODE=bitcode

xcodebuild -project "$PODS_PROJECT" \
  -sdk iphonesimulator -configuration Release -alltargets \
  ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=NO SYMROOT="$SYMROOT" \
  CLANG_ENABLE_MODULE_DEBUGGING=NO

