#!/bin/bash

if [[ -f "${HOME}/.config/dotfiles/" ]]; then
  rm -rf "${HOME}/.config/dotfiles/"
fi

git clone https://github.com/StepBroBD/Dotfiles.git "${HOME}/.config/dotfiles/"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${HOME}/.config/dotfiles/zsh/zsh-autosuggestions/"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.config/dotfiles/zsh/zsh-syntax-highlighting/"
git clone https://github.com/chisui/zsh-nix-shell.git "${HOME}/.config/dotfiles/zsh/zsh-nix-shell/"
git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

mkdir "${HOME}/.config"
mkdir "${HOME}/.gnupg"

ln -fsv "${HOME}/.config/dotfiles/zsh/zshrc ~/.zshrc"
ln -fsv "${HOME}/.config/dotfiles/tmux/tmux.conf ~/.tmux.conf"
ln -fsv "${HOME}/.tmux/plugins/ ~/.config/dotfiles/tmux/plugins"
ln -fsv "${HOME}/.config/dotfiles/gpg/gpg.conf ~/.gnupg/gpg.conf"
ln -fsv "${HOME}/.config/dotfiles/gpg/gpg-agent.conf ~/.gnupg/gpg-agent.conf"
ln -fsv "${HOME}/.config/dotfiles/nvim ~/.config"

if [[ $(command -v smimesign) > /dev/null ]]; then
  ln -fsv "${HOME}/.config/dotfiles/git/smime.gitconfig ~/.gitconfig"
else
  ln -fsv "${HOME}/.config/dotfiles/git/gpg.gitconfig ~/.gitconfig"
fi

chown -R "$(whoami)" "${HOME}/.gnupg/"
chmod 600 "${HOME}/.gnupg/*"
chmod 700 "${HOME}/.gnupg"

chmod +x "${HOME}/.config/dotfiles/nix/darwin-rebuild.sh"
chmod +x "${HOME}/.config/dotfiles/nix/nixos-rebuild.sh"

chsh -s /bin/zsh
