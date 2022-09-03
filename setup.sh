#!/bin/bash

if [[ -f ~/.config/dotfiles/ ]]; then
  rm -rf ~/.config/dotfiles/
fi

git clone https://github.com/StepBroBD/Dotfiles.git                ~/.config/dotfiles/
git clone https://github.com/zsh-users/zsh-autosuggestions.git     ~/.config/dotfiles/zsh/zsh-autosuggestions/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/dotfiles/zsh/zsh-syntax-highlighting/

mkdir ~/.config
mkdir ~/.gnupg

ln -fsv ~/.config/dotfiles/zsh/zshrc          ~/.zshrc
ln -fsv ~/.config/dotfiles/tmux/tmux.conf     ~/.tmux.conf
ln -fsv ~/.config/dotfiles/gpg/gpg.conf       ~/.gnupg/gpg.conf
ln -fsv ~/.config/dotfiles/gpg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
ln -fsv ~/.config/dotfiles/git/gitconfig      ~/.gitconfig
ln -fsv ~/.config/dotfiles/nvim               ~/.config

chown -R "$(whoami)" ~/.gnupg/
chmod 600            ~/.gnupg/*
chmod 700            ~/.gnupg

chsh -s /bin/zsh
