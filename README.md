# t3rnkey

[![release](https://img.shields.io/github/v/release/chiefbiiko/t3rnkey?include_prereleases)](https://github.com/chiefbiiko/t3rnkey/releases/latest) [![stability-experimental](https://img.shields.io/badge/stability-experimental-orange.svg)](https://github.com/chiefbiiko/t3rnkey)

A tiny `bash` wrapper combinin' [`t3rn`](https://github.com/t3rn/t3rn) compatible 🗝️ tools, currently [`subkey`](https://github.com/paritytech/substrate/tree/master/bin/utils/subkey) and [`moonkey`](https://github.com/PureStake/moonbeam/tree/master/bin/utils/moonkey), 2 🔌 & ▶️

Built 4 Linux 🐧

## Installation

```bash
curl -sSf https://raw.githubusercontent.com/chiefbiiko/t3rnkey/master/install.sh | sh
```

## Usage

```bash
t3rnkey polkadot # Gen a Substrate/Polkadot keypair
t3rnkey ethereum # Gen an Ethereum keypair
t3rnkey -h       # More help
t3rnkey -v       # All versions
```