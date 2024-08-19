{ inputs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [
    tmux
    zsh
  ];
}
