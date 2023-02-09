#!/bin/bash

if [[ -f "${HOME}/.config/dotfiles/" ]]; then
  rm -rf "${HOME}/.config/dotfiles/"
fi

git clone https://github.com/StepBroBD/Dotfiles.git "${HOME}/.config/dotfiles/"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${HOME}/.config/dotfiles/zsh/powerlevel10k/"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "${HOME}/.config/dotfiles/zsh/zsh-autosuggestions/"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.config/dotfiles/zsh/zsh-syntax-highlighting/"
git clone --depth=1 https://github.com/chisui/zsh-nix-shell.git "${HOME}/.config/dotfiles/zsh/zsh-nix-shell/"
git clone --depth=1 https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

mkdir "${HOME}/.config"
mkdir "${HOME}/.gnupg"

ln -fsv "${HOME}/.config/dotfiles/zsh/zshrc" "${HOME}/.zshrc"
ln -fsv "${HOME}/.config/dotfiles/zsh/p10k" "${HOME}/.p10k.zsh"
ln -fsv "${HOME}/.config/dotfiles/tmux/tmux.conf" "${HOME}/.tmux.conf"
ln -fsv "${HOME}/.tmux/plugins/" "${HOME}/.config/dotfiles/tmux/plugins"
ln -fsv "${HOME}/.config/dotfiles/gpg/gpg.conf" "${HOME}/.gnupg/gpg.conf"
ln -fsv "${HOME}/.config/dotfiles/gpg/gpg-agent.conf" "${HOME}/.gnupg/gpg-agent.conf"
ln -fsv "${HOME}/.config/dotfiles/nvim" "${HOME}/.config"

if [[ $(command -v smimesign) > /dev/null ]]; then
  ln -fsv "${HOME}/.config/dotfiles/git/smime.gitconfig" "${HOME}/.gitconfig"
else
  ln -fsv "${HOME}/.config/dotfiles/git/gpg.gitconfig" "${HOME}/.gitconfig"
fi

chown -R "$(whoami)" "${HOME}/.gnupg/"
chmod 600 "${HOME}/.gnupg/*"
chmod 700 "${HOME}/.gnupg"

chmod +x "${HOME}/.config/dotfiles/nix/darwin-rebuild.sh"
chmod +x "${HOME}/.config/dotfiles/nix/nixos-rebuild.sh"

chsh -s /bin/zsh

