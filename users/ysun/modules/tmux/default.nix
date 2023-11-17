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

    plugins = with pkgs.tmuxPlugins; [
      nord
      sensible
      resurrect
    ];

    extraConfig = ''
      set -g default-terminal "alacritty"
      set-option -ga terminal-overrides ",alacritty:Tc"

      set -g mouse on
      set -g status on
      set -g status-position top
      set -g status-justify centre

      set -g base-index 1
      setw -g pane-base-index 1

      set -g allow-rename on
      setw -g automatic-rename
      set-option -g renumber-windows on

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      bind r source-file ~/.tmux.conf \; display-message "tmux: config reloaded"
      bind s set-window-option synchronize-panes\; display-message "synchronize-panes: #{?pane_synchronized,on,off}"
    '';
  };
}
