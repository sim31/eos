#!/bin/bash

if [[ $# != 1 || $1 == "-h" || $1 == "--help" ]]; then
  echo "Usage: install.sh <install_dir>"
  exit 1
fi

if [ ! -d $1 ]; then
  echo "$1 does not exist"
  exit 1
fi

INCLUDE="$1/include"
SHARE="$1/share"

if [ ! -d $INCLUDE ]; then
  mkdir "$1/include"
fi
if [ ! -d $SHARE ]; then
  mkdir "$1/share"
fi

cp -r contracts/skeleton $SHARE
cp -r contracts/eoslib/ $INCLUDE

