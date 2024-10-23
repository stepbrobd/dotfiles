{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;

    keyMode = "vi";
    mouse = true;
    clock24 = true;
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [ nord resurrect ];
    sensibleOnTop = false;

    extraConfig = ''
      # tmux-sensible
      set -s escape-time 0
      set -g history-limit 99999
      set -g display-time 2500
      set -g status-interval 5
      set -g status-keys emacs
      set -g focus-events on
      setw -g aggressive-resize on
      bind C-p previous-window
      bind C-n next-window
      set -g default-command "$SHELL"

      set -g status on
      set -g status-position top

      set -g base-index 1
      setw -g pane-base-index 1

      set -g allow-rename on
      setw -g automatic-rename
      set-option -g renumber-windows on

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux: config reloaded"
      bind s set-window-option synchronize-panes\; display-message "synchronize-panes: #{?pane_synchronized,on,off}"
    '';
  };
}
