#!/bin/zsh

attr=$([ $(uname -m) = "x86_64" ] && echo "x86_64" || echo "aarch64")

printf "\e[36;1mThis operation requires \`sudo\`\e[0m\n"
sudo echo -n

pushd /tmp >/dev/null

if [ -e ./stepbrobd-dotfiles-loader/flake.nix ]; then
    rm -rf ./stepbrobd-dotfiles-loader
fi

sudo -i nix-channel --update
(yes "" | sh <(curl -L https://mynixos.com/install-loader) stepbrobd/dotfiles) >/dev/null 2>&1
(nix flake lock ./stepbrobd-dotfiles-loader) >/dev/null 2>&1
nixos-rebuild switch --flake ./stepbrobd-dotfiles-loader\#$attr --show-trace

if [ -e ./stepbrobd-dotfiles-loader/flake.nix ]; then
    rm -rf ./stepbrobd-dotfiles-loader
fi

popd >/dev/null
