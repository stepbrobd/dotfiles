# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";

      height = 30;

      modules-left = [ "clock" ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ "clock" ];

      "clock" = {
        interval = 1;
        tooltip = false;
        format = "{:%a %b %d %H:%M:%S}";
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        active-only = false;
      };
    };

    # Nord theme
    style = ''
      * {
          min-height: 0;
          color: #d8dee9;
          border: none;
          border-radius: 8px;
          font-size: 12px;
          font-weight: bold;
          font-family: "Noto Sans", "Noto Color Emoji";
      }

      window#waybar {
        background: rgba(0, 0, 0, 0);
      }

      window#waybar.empty {
        background: rgba(0, 0, 0, 0);
      }

      .modules-left {
        margin-left: 4px;
      }

      .modules-right {
        margin-right: 4px;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        margin-top: 4px;
        padding: 0 4px;
        border: 2px solid #4c566a;
      	background-color: rgba(46, 52, 64, 0.75);
      }

      #clock { all: inherit; }
    '';
  };
}
