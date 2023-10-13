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

      height = 36;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ ];

      "clock" = {
        interval = 1;
        tooltip = false;
        format = "{:%a %b %d %H:%M:%S}";
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        format-icons = {
          "1" = "󰬺";
          "2" = "󰎧";
          "3" = "󰲤";
          "4" = "󰎮";
          "5" = "󰼓";
          "6" = "󰎴";
          "7" = "󰼕";
          "8" = "";
          "9" = "";
          "10" = "";
        };
      };

      "hyprland/window" = {
        format = "{title}";
      };
    };

    style = ''
      * {
          min-height: 0;
          color: #d8dee9;
          border: none;
          border-radius: 8px;
          font-size: 12px;
          font-family: "Noto Sans", "Font Awesome 6 Free";
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
        padding: 0 8px;
        border: 2px solid #4c566a;
      	background-color: rgba(46, 52, 64, 0.75);
      }
    '';
  };
}
