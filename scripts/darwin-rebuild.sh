#!/bin/bash

if [[ $(uname) == "Darwin" ]]; then
  printf "\e[36;1mThis operation requires \`sudo\`\e[0m\n"
  sudo echo -n

  pushd $TMPDIR >/dev/null
  if [ -e ./stepbrobd-dotfiles-loader/flake.nix ]; then
    rm -rf ./stepbrobd-dotfiles-loader
  fi

  sudo -i nix-channel --update
  (yes "" | sh <(curl -L https://mynixos.com/install-loader) stepbrobd/dotfiles) >/dev/null 2>&1
  (nix flake lock ./stepbrobd-dotfiles-loader) >/dev/null 2>&1
  darwin-rebuild switch --flake ./stepbrobd-dotfiles-loader\#aarch64 --show-trace

  if [ -e ./stepbrobd-dotfiles-loader/flake.nix ]; then
    rm -rf ./stepbrobd-dotfiles-loader
  fi
  popd >/dev/null
fi
