#!/bin/bash

if [[ -f ~/.dotfiles/ ]]; then
  rm -rf ~/.dotfiles/
fi

git clone https://github.com/StepBroBD/Dotfiles.git ~/.dotfiles/
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.dotfiles/zsh/zsh-autosuggestions/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.dotfiles/zsh/zsh-syntax-highlighting/

mkdir ~/.config
mkdir ~/.gnupg

ln -fsv ~/.dotfiles/zsh/zshrc ~/.zshrc
ln -fsv ~/.dotfiles/gpg/gpg.conf ~/.gnupg/gpg.conf
ln -fsv ~/.dotfiles/git/gitconfig ~/.gitconfig
ln -fsv ~/.dotfiles/nvim ~/.config

chown -R "$(whoami)" ~/.gnupg/
chmod 600 ~/.gnupg/*
chmod 700 ~/.gnupg

/bin/zsh
sourec ~/.zshrc
