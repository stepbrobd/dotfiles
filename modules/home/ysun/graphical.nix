{ inputs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [
    minimal

    alacritty
    ani
    attic
    atuin
    bat
    btop
    # chromium # linux only
    direnv
    # firefox # linux only
    # floorp # linux only
    fzf
    gh
    git
    gpg
    # hyprland # linux only
    jujutsu
    lsd
    # mpd # linux only
    # nushell # imported in minimal
    ssh
    # tmux # imported in minimal
    vscode
    zathura
    zoxide
    # zsh # imported in minimal
  ];
}
