#!/bin/bash

if [[ $# < 2 || $1 == "-h" || $1 == "--help" ]]; then
  echo "Usage: eosacc <account-name> <creator-account> [key-dir]"
  echo "Default wallet must have proper permisions and be unlocked!"
  exit 1
fi


account=$1
creator=$2

if [[ $# > 2 ]]; then
  keyDir=$3
else
  keyDir=./
fi

active_str=`eosc create key`
owner_str=`eosc create key`

active_pub=`echo "$active_str" | grep -oP "Public key: \K.*"`
owner_pub=`echo "$owner_str" | grep -oP "Public key: \K.*"`

eosc create account $creator $account $owner_pub $active_pub

r=$?
if [[ $r != 0 ]]; then
  exit $r
fi

echo "$active_str" > "$keyDir/$account-active-key"
echo "$owner_str" > "$keyDir/$account-owner-key"

active_prv=`echo "$active_str" | grep -oP "Private key: \K.*"`

eosc wallet import "$active_prv"

