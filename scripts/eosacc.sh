#!/bin/bash

function print_help() {
  echo "Usage: eosacc -c|-p <account-name> <creator-account> [key-dir]"
  echo "Options: -c --create          create keys and account on the blockchain."
  echo "                                Default wallet has to have proper permisions and "
  echo "                                be unlocked."
  echo "         -p --publish         create account on the blockchain with existing keys,"
  echo "                               located in key-dir or in the working dir."
}

if [[ $# < 3 || $1 == "-h" || $1 == "--help" ]]; then
  print_help
  exit 1
fi

option=$1
account=$2
creator=$3

if [[ $# > 3 ]]; then
  keyDir=$4
else
  keyDir=./
fi

function publish_account {
  active_pub=`echo "$1" | grep -oP "Public key: \K.*"`
  owner_pub=`echo "$2" | grep -oP "Public key: \K.*"`

  eosc create account $creator $account $owner_pub $active_pub
}


if [[ $option == "-c" || $option == "--create" ]]; then 
  active_str=`eosc create key`
  owner_str=`eosc create key`

  publish_account "$active_str" "$owner_str"
  r=$?
  if [[ $r != 0 ]]; then
    exit $r
  fi

  echo "$active_str" > "$keyDir/$account-active-key"
  echo "$owner_str" > "$keyDir/$account-owner-key"
  active_prv=`echo "$active_str" | grep -oP "Private key: \K.*"`

  eosc wallet import "$active_prv"

elif [[ $option == "-p" || $option == "--publish" ]]; then
  active_str=`cat "$keyDir/$account-active-key"`
  owner_str=`cat "$keyDir/$account-owner-key"`
  publish_account "$active_str" "$owner_str"
else
  echo "Unknown option $option"
  print_help
  exit 1
fi
