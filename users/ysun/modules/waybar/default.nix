# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.waybar = {
    enable = true;

    settings = {
      layer = "top";
      position = "top";

      modules-left = [ ];
      modules-center = [ "hyprland/window" ];
      modules-right = [ ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        active-only = false;
      };
    };

    style = ''
    
    '';
  };
}
