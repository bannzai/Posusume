#!/bin/bash

echo 'Start `Apollo`'

echo "Print current working directory"
cd `dirname $0`
cd ApolloCodegen
pwd

xcrun -sdk macosx swift run ApolloCodegen 

cd -

