#!/bin/bash

VERSION=0.1.0
SUBKEY_VERSION=2.0.1
MOONKEY_VERSION=0.1.0

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
    latest      Update t3rnkey, subkey and moonkey to their latest versions

For separate subcommand help/version info run:
    t3rnkey polkadot|ethereum -h|--help|-v|--version"
}

t3rnkey_latest() {
  # Checks...
  if [ ! -d /usr/local/bin ]; then
    echo "error: /usr/local/bin does not exist" 1>&2
    exit 1
  fi

  # ...Maybe usin' sudo 2 write to /usr/local/bin
  if [ ! -O /usr/local/bin ]; then
    sudo_maybe=sudo
  fi

  $sudo_maybe curl -sSfLo /usr/local/bin/t3rnkey \
    https://raw.githubusercontent.com/chiefbiiko/t3rnkey/master/t3rnkey.sh

  $sudo_maybe chmod +x /usr/local/bin/t3rnkey

  # We need substrate build deps 2 install subkey & moonkey
  # `--fast` flag 2 get the deps without installin' substrate & subkey
  curl -sSf https://getsubstrate.io | bash -s -- --fast

  # Installin' only `subkey`, @ a specific version of the subkey crate
  cargo install subkey --version $SUBKEY_VERSION --locked \
    --git https://github.com/paritytech/substrate

  # Installin' moonkey
  cargo install moonkey --version $MOONKEY_VERSION --locked \
    --git https://github.com/PureStake/moonbeam
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
  if [[ ! -x /usr/local/bin/t3rnkey ]]; then
    t3rnkey_latest
  else
    t3rnkey_${subcommand} "$@"
  fi
  ;;
esac
