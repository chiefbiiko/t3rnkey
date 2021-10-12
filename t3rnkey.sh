#!/bin/bash

# Requires: bash, basename, curl

VERSION=0.1.0

t3rnkey_version(){
  echo "t3rnkey v$VERSION"
  subkey --version
  moonkey --version
}

t3rnkey_help(){
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
  # Fetchin' and overwritin' self
  if [ ! -d /usr/local/bin ]; then
    echo "/usr/local/bin does not exist" 1>&2
    exit 1
  fi

  # Maybe usin' sudo 2 write to /usr/local/bin
  if [ ! -O /usr/local/bin ]; then
    sudo_maybe=sudo
  fi

  $sudo_maybe curl -sSfLo /usr/local/bin/t3rnkey \
    https://raw.githubusercontent.com/chiefbiiko/t3rnkey/v$VERSION/t3rnkey.sh

  $sudo_maybe chmod +x /usr/local/bin/t3rnkey

  # Fetchin' the latest release URLs for subkey and moonkey...
  subkey_latest=$( \
    curl -sSfLI -o /dev/null -w %{url_effective} \
    https://github.com/paritytech/substrate/releases/latest \
  )
  moonkey_latest=$( \
    curl -sSfLI -o /dev/null -w %{url_effective} \
    https://github.com/PureStake/moonbeam/releases/latest \
  )

  # ...Extractin' their latest versions
  subkey_version=${subkey_latest#*/v} 
  moonkey_version=${moonkey_latest#*/v}

  # We need substrate build deps 2 install subkey & moonkey
  # `--fast` flag 2 get the deps without installin' substrate & subkey
  curl -sSf https://getsubstrate.io | bash -s -- --fast

  # Installin' only `subkey`, @ a specific version of the subkey crate
  cargo install subkey --version $subkey_version --locked \
    --git https://github.com/paritytech/substrate

  # Installin' moonkey
  cargo install moonkey --version $moonkey_version --locked \
    --git https://github.com/PureStake/moonbeam
}

t3rnkey_polkadot(){
  subkey generate $@
}

t3rnkey_ethereum(){
  moonkey $@
}

subcommand=$1
install=$2

case $subcommand in
  "" | "-h" | "--help")
  t3rnkey_help
  ;;
  "-V" | "-v" | "--version")
  t3rnkey_version
  ;;
  *)
  shift
  "t3rnkey_${subcommand}" "$@"
  code=$?
  if [[ $code -ne 0 ]]; then
    echo "error: unknown subcommand '$subcommand' - run 't3rnkey --help'" 1>&2
    exit $code
  fi
  ;;
esac