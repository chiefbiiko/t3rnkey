SUBKEY_VERSION=2.0.1
MOONKEY_VERSION=0.1.1

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
getsubstrate=$(mktemp --suffix .sh)
curl -sSfLo $getsubstrate https://getsubstrate.io
chmod 700 $getsubstrate
$getsubstrate --fast

# Installin' only `subkey`, @ a specific version of the subkey crate
cargo install subkey --version $SUBKEY_VERSION --locked \
  --git https://github.com/paritytech/substrate

# Installin' moonkey
cargo install moonkey --version $MOONKEY_VERSION --locked \
  --git https://github.com/PureStake/moonbeam
