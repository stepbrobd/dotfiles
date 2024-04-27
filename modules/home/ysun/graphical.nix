# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  imports = [
    ./minimal.nix

    ./alacritty
    ./atuin
    ./bat
    ./btop
    # ./chromium # linux only
    ./direnv
    # ./firefox # linux only
    # ./floorp # linux only
    ./fzf
    ./gh
    ./git
    ./gpg
    # ./hyprland # linux only
    ./lsd
    # ./mpd # linux only
    ./nushell
    ./pyenv
    # ./tmux # imported in minimal
    ./vscode
    ./zathura
    ./zoxide
    # ./zsh # imported in minimal
  ];
}
