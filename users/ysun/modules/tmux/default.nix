# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.tmux = {
    enable = true;

    keyMode = "vi";
    mouse = true;
    clock24 = true;
    terminal = "screen-256color";

    plugins = [

    ];

    extraConfig = ''
      set -g base-index 1
      setw -g pane-base-index 1
    '';
  };
}
