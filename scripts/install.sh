#!/bin/bash

if [[ $# != 2 || $1 == "-h" || $1 == "--help" ]]; then
  echo "Usage: install.sh <install_dir> <build_dir>"
  exit 1
fi

if [ ! -d $1 ]; then
  echo "$1 does not exist"
  exit 1
fi

INCLUDE="$1/include"
SHARE="$1/share"
BIN="$1/bin"

mkdir -p $INCLUDE
mkdir -p $SHARE
mkdir -p $BIN

# if [ ! -d $INCLUDE ]; then
#   mkdir "$1/include"
# fi
# if [ ! -d $SHARE ]; then
#   mkdir "$1/share"
# fi

cp -r contracts/skeleton $SHARE
cp -r contracts/eoslib/ $INCLUDE
cp "$2/programs/abi_gen/abi_gen" $BIN
cp "$2/programs/codegen/codegen" $BIN

