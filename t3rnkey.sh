#!/bin/bash

# Requires: bash, basename, curl

VERSION=0.1.0
NAME=$(basename $0 .sh)

t3rnkey_version(){
  echo "$NAME v$VERSION"
  subkey --version
  moonkey --version
}

t3rnkey_help(){
  echo "$NAME v$VERSION

Generate keypairs for t3rn compatible/connected chains

USAGE:
    $NAME [SUBCOMMAND] [FLAGS] [OPTIONS]

SUBCOMMANDS:
    polkadot    Generate Polkadot keypairs with subkey
    ethereum    Generate Ethereum keypairs with moonkey
    latest      Update t3rnkey, subkey and moonkey to their latest versions

For separate subcommand help/version info run:
    $NAME polkadot|ethereum -h|--help|-v|--version"
}

t3rnkey_latest() {
  # Fetchin' and overwritin' self
  if [ ! -d /usr/local/bin ]; then
    echo "/usr/local/bin does not exist" 1>&2
    exit 1
  fi

  # Maybe usin' sudo 2 write to /usr/local/bin
  if [ ! -O /usr/local/bin ]; then
    SUDO_MAYBE=sudo
  fi

  $SUDO_MAYBE curl -sSfLo /usr/local/bin/$NAME \
    https://raw.githubusercontent.com/chiefbiiko/t3rnkey/v$VERSION/t3rnkey.sh

  $SUDO_MAYBE chmod +x /usr/local/bin/$NAME

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

case $subcommand in
  "" | "-h" | "--help")
  t3rnkey_help
  ;;
  "-V" | "-v" | "--version")
  t3rnkey_version
  ;;
  *)
  shift
  if ! t3rnkey_${subcommand} $@; then
    code=$?
    echo "error: unknown subcommand '$subcommand' - run '$NAME --help'" 1>&2
    exit $code
  fi
  ;;
esac