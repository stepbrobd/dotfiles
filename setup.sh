#!/bin/zsh

function clone() {
  url=$1
  dst=$2
  mkdir -p $dst
  pushd $dst >/dev/null
  /usr/bin/git init
  if ! /usr/bin/git config remote.origin.url &>/dev/null; then
    /usr/bin/git remote add origin $url
  fi
  /usr/bin/git fetch origin master
  /usr/bin/git reset origin/master
  popd >/dev/null
}

clone git@github.com:StepBroBD/Dotfiles.git "${HOME}/.config/dotfiles/"
clone https://github.com/romkatv/powerlevel10k.git "${HOME}/.config/dotfiles/zsh/powerlevel10k/"
clone https://github.com/zsh-users/zsh-autosuggestions.git "${HOME}/.config/dotfiles/zsh/zsh-autosuggestions/"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${HOME}/.config/dotfiles/zsh/zsh-syntax-highlighting/"
clone https://github.com/chisui/zsh-nix-shell.git "${HOME}/.config/dotfiles/zsh/zsh-nix-shell/"
clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

mkdir -p "${HOME}/.config"
mkdir -p "${HOME}/.gnupg"

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

