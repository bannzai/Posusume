#!/bin/bash
set -eu
set -o pipefail

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"
PROJECT_DIR="$(cd $SCRIPT_DIR && cd ../.. && pwd -P)"

cat $PROJECT_DIR/Sources/Core/Secret.swift.sample | sed \
  -e "s|\[APP_API_ENDPOINT\]|$APP_API_ENDPOINT|g" \
> $PROJECT_DIR/Sources/Core/Secret.swift

