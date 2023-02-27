#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
  printf "\e[36;1mThis operation requires \`sudo\`\e[0m\n"
  sudo echo -n

  pushd $TMPDIR >/dev/null

  if [ -e ./flake-aarch-64-darwin-loader/flake.nix ]; then
    rm -rf ./flake-aarch-64-darwin-loader
  fi

  (yes "" | sh <(curl -L https://mynixos.com/install-loader) flake/aarch64-darwin) >/dev/null 2>&1
  sudo -i nix-channel --update
  (nix flake lock ./flake-aarch-64-darwin-loader) >/dev/null 2>&1
  darwin-rebuild switch --flake ./flake-aarch-64-darwin-loader\#aarch64 --show-trace

  popd >/dev/null
fi
