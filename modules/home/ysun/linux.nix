{ inputs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [
    graphical

    # alacritty # imported in graphical
    # atuin # imported in graphical
    # bat # imported in graphical
    # btop # imported in graphical
    chromium # linux only
    # direnv # imported in graphical
    # firefox # linux only
    floorp # linux only
    # fzf # imported in graphical
    # git # imported in graphical
    # gpg # imported in graphical
    hey
    hyprland # linux only
    # lsd # imported in graphical
    mpd # linux only
    # nushell # imported in graphical
    # tmux # imported in minimal
    # vscode # imported in graphical
    # zathura # imported in graphical
    # zoxide # imported in graphical
    # zsh # imported in minimal
  ];
}
