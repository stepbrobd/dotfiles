{ inputs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [
    nushell
    tmux
    # zellij
    zsh
  ];
}
