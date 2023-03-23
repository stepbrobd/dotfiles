#!/usr/bin/env nix-shell
#!nix-shell -i zsh -p curl git perl smimesign

set -eo pipefail

export PATH="$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin" && PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

# Disable prompt
touch "${HOME}/.hushlogin"

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
  git reset origin/master
  popd >/dev/null
}

# Setup
mkdir -p "${HOME}/.config"
clone git@github.com:stepbrobd/dotfiles.git "${HOME}/.config/dotfiles/"

# Z-Shell
clone https://github.com/romkatv/powerlevel10k.git "${HOME}/.config/dotfiles/zsh/powerlevel10k/"
clone https://github.com/zsh-users/zsh-autosuggestions.git "${HOME}/.config/dotfiles/zsh/zsh-autosuggestions/"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.config/dotfiles/zsh/zsh-syntax-highlighting/"
clone https://github.com/chisui/zsh-nix-shell.git "${HOME}/.config/dotfiles/zsh/zsh-nix-shell/"
ln -fsv "${HOME}/.config/dotfiles/zsh/zshrc" "${HOME}/.zshrc"
ln -fsv "${HOME}/.config/dotfiles/zsh/p10k" "${HOME}/.p10k.zsh"

# Git
if [[ $(command -v smimesign) > /dev/null ]]; then
  ln -fsv "${HOME}/.config/dotfiles/git/smime.gitconfig" "${HOME}/.gitconfig"
else
  ln -fsv "${HOME}/.config/dotfiles/git/gpg.gitconfig" "${HOME}/.gitconfig"
fi

# GPG
mkdir -p "${HOME}/.gnupg"
ln -fsv "${HOME}/.config/dotfiles/gpg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ln -fsv "${HOME}/.config/dotfiles/gpg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
chown -R "$(whoami)" "${HOME}/.gnupg/"
chmod 600 "${HOME}/.gnupg/gpg.conf"
chmod 600 "${HOME}/.gnupg/gpg-agent.conf"
chmod 700 "${HOME}/.gnupg"

# Neovim
ln -fsv "${HOME}/.config/dotfiles/nvim" "${HOME}/.config"

# Tmux
clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"
ln -fsv "${HOME}/.config/dotfiles/tmux/tmux.conf" "${HOME}/.tmux.conf"
ln -fsv "${HOME}/.tmux/plugins/" "${HOME}/.config/dotfiles/tmux/plugins"

source "${HOME}/.zshrc"
