#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
  pushd $TMPDIR >/dev/null

  if [ -e ./flake-aarch-64-darwin-loader/flake.nix ]; then
    rm -rf ./flake-aarch-64-darwin-loader
  fi

  (yes "" | sh <(curl -L https://mynixos.com/install-loader) flake/aarch64-darwin) >/dev/null 2>&1
  (nix flake lock ./flake-aarch-64-darwin-loader) >/dev/null 2>&1
  darwin-rebuild switch --flake ./flake-aarch-64-darwin-loader\#aarch64

  popd >/dev/null
fi
