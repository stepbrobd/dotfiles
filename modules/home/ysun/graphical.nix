{ inputs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [
    minimal
    nix

    alacritty
    atuin
    bat
    btop
    email
    direnv
    fzf
    gh
    ghostty
    git
    gpg
    jq
    jujutsu
    lazygit
    llm
    lsd
    man
    media
    # mpd # linux only
    neovide
    neovim
    niks3
    # nushell # imported in minimal
    openconnect
    openvpn
    ripgrep
    ssh
    # tmux # imported in minimal
    yazi
    zoxide
    # zsh # imported in minimal
  ];
}
