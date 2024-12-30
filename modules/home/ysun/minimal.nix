{ inputs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [
    nushell
    tmux
    zsh
  ];
}
