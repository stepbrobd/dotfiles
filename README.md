# Dotfiles

Dotfiles storage bucket with setup scripts.

The content of this repository should stay in ~/.dotfiles directory.

## Setup

```shell
curl --proto '=https' --tlsv1.3 -sSf https://raw.githubusercontent.com/StepBroBD/Dotfiles/master/setup.sh | bash
```

## Symlinks

- ~/.dotfiles/zsh/[zshrc](/zsh/zshrc) -> ~/.zshrc

- ~/.dotfiles/[nvim](/nvim) -> ~/.config/nvim

- ~/.dotfiles/git/[gitconfig](/git/gitconfig) -> ~/.gitconfig

- ~/.dotfiles/gpg/[gpg.conf](/gpg/gpg.conf) -> ~/.gnupg/gpg.conf

## License

This repository content excluding all submodules is licensed under the [WTFPL License](LICENSE.md), third-party code are subject to their original license.
