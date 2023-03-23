#!/bin/zsh

if [[ $(command -v nix) ]]; then
	attr=$(nix --extra-experimental-features nix-command eval --impure --raw --expr 'builtins.currentSystem')
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

printf "\e[36;1mRebuilding system with \e[4m$rebuild\e[0m\e[36;1m with output attribute of \e[4m$attr\e[0m\e[36;1m\e[0m\n"

pushd $TMPDIR >/dev/null

if [ -e ./stepbrobd-dotfiles-loader/flake.nix ]; then
	rm -r ./stepbrobd-dotfiles-loader
fi

sudo -i nix-channel --update
(yes "" | sh <(curl -L https://mynixos.com/install-loader) stepbrobd/dotfiles) >/dev/null 2>&1
(nix --extra-experimental-features nix-command --extra-experimental-features flakes flake lock ./stepbrobd-dotfiles-loader) >/dev/null 2>&1

$rebuild switch --flake ./stepbrobd-dotfiles-loader\#$attr "$@"

if [ -e ./stepbrobd-dotfiles-loader/flake.nix ]; then
	rm -r ./stepbrobd-dotfiles-loader
fi

popd >/dev/null
