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
      spacing = 24;

      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "network" "battery" ];

      "hyprland/workspaces" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          "1" = "󰼏";
          "2" = "󰼐";
          "3" = "󰼑";
          "4" = "󰼒";
          "5" = "󰼓";
          "6" = "󰼔";
          "7" = "󰼕";
          "8" = "󰼖";
          "9" = "󰼗";
          "10" = "󰿪";
        };
      };

      "hyprland/window" = {
        tooltip = false;
        format = "{title}";
        separate-outputs = true;
      };

      "clock" = {
        tooltip = false;
        interval = 1;
        format = "{:%a %b %d %H:%M:%S}";
      };

      "network" = {
        tooltip = false;
        format-wifi = "󰤨   {essid}";
        format-ethernet = "󰈀   {ipaddr}";
        format-disconnected = "󰌙   {ifname}";
        format-linked = "󰿨   {ifname}";
        on-click = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
      };

      "battery" = {
        tooltip = false;
        states = {
          warning = 20;
          critical = 10;
        };
        format = "{icon}   {capacity}%";
        format-charging = "󰂄";
        format-plugged = "󰂄";
        format-icons = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" "󱈏" ];
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
      	transition: all 0.25s ease-in-out;
      }

      window#waybar,
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

      button {
        padding: 0;
      	margin-right: 8px;
      }

      button:hover {
        background: none;
      	box-shadow: none;
      	text-shadow: none;
      	transition: none;
      	border: none;
      	border-color: transparent;
      }
    '';
  };
}
