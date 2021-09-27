#!/bin/bash

echo 'Start `Apollo`'

SCRIPT_DIR="$(cd `dirname $0` && pwd -P)"

# ApolloCodegen uses relative paths. So, move the path
cd $SCRIPT_DIR
xcrun -sdk macosx swift run ApolloCodegen 
cd -
