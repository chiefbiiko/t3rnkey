#!/bin/bash

VERSION=0.1.0

t3rnkey_version() {
  echo "t3rnkey v$VERSION"
  subkey --version
  moonkey --version
}

t3rnkey_help() {
  echo "t3rnkey v$VERSION

Generate keypairs for t3rn compatible/connected chains

USAGE:
    t3rnkey [SUBCOMMAND] [FLAGS] [OPTIONS]

SUBCOMMANDS:
    polkadot    Generate Polkadot keypairs with subkey
    ethereum    Generate Ethereum keypairs with moonkey

For separate subcommand help/version info run:
    t3rnkey polkadot|ethereum -h|--help|-v|--version"
}

t3rnkey_polkadot() {
  subkey generate "$@"
}

t3rnkey_ethereum() {
  moonkey "$@"
}

# mainish

subcommand=$1
case $subcommand in
"" | "-h" | "--help")
  t3rnkey_help
  ;;
"-V" | "-v" | "--version")
  t3rnkey_version
  ;;
*)
  last_arg="${@: -1}"
  shift
  # Workaround to enable '-v' as version flag
  if [ "$last_arg" = "-v" ]; then
    t3rnkey_${subcommand} --version
  else
    t3rnkey_${subcommand} "$@"
  fi
  ;;
esac
