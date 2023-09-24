#!/usr/bin/env zsh

set -eo pipefail

export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" && PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

function clone() {
	url=$1
	dst=$2
	mkdir -p $dst
	pushd $dst >/dev/null
	git init
	if ! git config remote.origin.url &>/dev/null; then
		git remote add origin $url
	fi
	git fetch origin master
	git reset --hard origin/master
	popd >/dev/null
}

CONFIG_ROOT="${HOME}/.config/dotfiles"

# Disable prompt
touch "${HOME}/.hushlogin"

# Setup
mkdir -p "${CONFIG_ROOT}"
clone git@github.com:stepbrobd/dotfiles "${CONFIG_ROOT}"

# Repos
ln -fsv "${CONFIG_ROOT}/repos" "${HOME}/.config"

# Nix
ln -fsv "${CONFIG_ROOT}/nix" "${HOME}/.config"
ln -fsv "${CONFIG_ROOT}/nixpkgs" "${HOME}/.config"

# Z-Shell
clone https://github.com/romkatv/powerlevel10k "${CONFIG_ROOT}/zsh/powerlevel10k/"
clone https://github.com/zsh-users/zsh-autosuggestions "${CONFIG_ROOT}/zsh/zsh-autosuggestions/"
clone https://github.com/zsh-users/zsh-syntax-highlighting "${CONFIG_ROOT}/zsh/zsh-syntax-highlighting/"
clone https://github.com/chisui/zsh-nix-shell "${CONFIG_ROOT}/zsh/zsh-nix-shell/"
ln -fsv "${CONFIG_ROOT}/zsh/zshrc" "${HOME}/.zshrc"
ln -fsv "${CONFIG_ROOT}/zsh/p10k" "${HOME}/.p10k.zsh"

# Git
ln -fsv "${CONFIG_ROOT}/git/config" "${HOME}/.gitconfig"

# GPG
mkdir -p "${HOME}/.gnupg"
ln -fsv "${CONFIG_ROOT}/gpg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ln -fsv "${CONFIG_ROOT}/gpg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
chown -R "$(whoami)" "${HOME}/.gnupg/"
chmod 600 "${HOME}/.gnupg/gpg.conf"
chmod 600 "${HOME}/.gnupg/gpg-agent.conf"
chmod 700 "${HOME}/.gnupg"

# Neovim
ln -fsv "${CONFIG_ROOT}/nvim" "${HOME}/.config"

# Tmux
clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
ln -fsv "${CONFIG_ROOT}/tmux/tmux.conf" "${HOME}/.tmux.conf"
ln -fsv "${HOME}/.tmux/plugins/" "${CONFIG_ROOT}/tmux/plugins"

# Discord
ln -fsv "${CONFIG_ROOT}/discord" "${HOME}/.config"

source "${HOME}/.zshrc"
