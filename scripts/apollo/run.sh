#!/bin/bash

echo 'Start `Apollo`'

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

xcrun -sdk macosx swift run $SCRIPT_DIR/ApolloCodegen 

