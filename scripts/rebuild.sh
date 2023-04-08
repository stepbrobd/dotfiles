#!/bin/zsh

set -eo pipefail

if [[ $(command -v nix) ]]; then
	attr=$(nix --extra-experimental-features nix-command eval --impure --raw --expr "builtins.currentSystem")
else
	printf "\e[31;1mCannot rebuild system: \`nix\` not available\e[0m\n"
	exit 1
fi

if [[ $(command -v nixos-rebuild) ]]; then
	rebuild="nixos-rebuild"
elif [[ $(command -v darwin-rebuild) ]]; then
	rebuild="darwin-rebuild"
else
	printf "\e[31;1mCannot rebuild system: \`nixos-rebuild\` or \`darwin-rebuild\` not available\e[0m\n"
	exit 1
fi

printf "\e[36;1mThis operation requires \`sudo\`\e[0m\n"
sudo echo -n

printf "\e[36;1mRebuilding system with \e[4m$rebuild\e[0m\e[36;1m using output attribute \e[4m$attr\e[0m\e[36;1m\e[0m\n"

pushd "$HOME/.config/dotfiles" >/dev/null

sudo -i nix-channel --update
nix --extra-experimental-features nix-command --extra-experimental-features flakes flake update --commit-lock-file

$rebuild switch --flake .#$attr "$@"

popd >/dev/null
