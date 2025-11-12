{ config, lib, ... }:

{
  config = lib.mkIf config.wayland.windowManager.hyprland.enable {
    programs.rofi = {
      enable = true;

      cycle = true;
      font = "Noto Sans 12";
      location = "center";
      terminal = "${config.home.sessionVariables.TERM}";

      xoffset = 0;
      yoffset = -250;

      theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "*" = {
            nord0 = mkLiteral "#2e3440";
            nord1 = mkLiteral "#3b4252";
            nord2 = mkLiteral "#434c5e";
            nord3 = mkLiteral "#4c566a";
            nord4 = mkLiteral "#d8dee9";
            nord5 = mkLiteral "#e5e9f0";
            nord6 = mkLiteral "#eceff4";
            nord7 = mkLiteral "#8fbcbb";
            nord8 = mkLiteral "#88c0d0";
            nord9 = mkLiteral "#81a1c1";
            nord10 = mkLiteral "#5e81ac";
            nord11 = mkLiteral "#bf616a";
            nord12 = mkLiteral "#d08770";
            nord13 = mkLiteral "#ebcb8b";
            nord14 = mkLiteral "#a3be8c";
            nord15 = mkLiteral "#b48ead";
            foreground = mkLiteral "var(nord9)";
            backlight = mkLiteral "#ccffeedd";
            background-color = mkLiteral "transparent";
            highlight = mkLiteral "underline bold #eceff4";
            transparent = mkLiteral "rgba(46,52,64,0)";
          };
          "window" = {
            location = mkLiteral "center";
            anchor = mkLiteral "center";
            transparency = "screenshot";
            padding = 10;
            border = 0;
            border-radius = 6;
            background-color = mkLiteral "var(transparent)";
            spacing = 0;
            children = mkLiteral "[mainbox]";
            orientation = mkLiteral "horizontal";
          };
          "mainbox" = {
            spacing = 0;
            children = mkLiteral "[inputbar, message, listview]";
          };
          "message" = {
            color = mkLiteral "var(nord0)";
            padding = 5;
            border-color = mkLiteral "var(foreground)";
            border = mkLiteral "0px 2px 2px 2px";
            background-color = mkLiteral "var(nord7)";
          };
          "inputbar" = {
            color = mkLiteral "var(nord6)";
            padding = mkLiteral "11px";
            background-color = mkLiteral "#3b4252";
            border = 1;
            border-radius = mkLiteral "6px 6px 0px 0px";
            border-color = mkLiteral "var(nord10)";
          };
          "entry, prompt, case-indicator" = {
            text-font = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          "prompt" = {
            margin = mkLiteral "0px 1em 0em 0em";
          };
          "listview" = {
            padding = mkLiteral "8px";
            border-radius = mkLiteral "0px 0px 6px 6px";
            border-color = mkLiteral "var(nord10)";
            border = mkLiteral "0px 1px 1px 1px";
            background-color = mkLiteral "rgba(46,52,64,0.9)";
            dynamic = false;
          };
          "element" = {
            padding = mkLiteral "3px";
            vertical-align = mkLiteral "0.5";
            border-radius = 4;
            background-color = mkLiteral "transparent";
            color = mkLiteral "var(foreground)";
            text-color = mkLiteral "rgb(216, 222, 233)";
          };
          "element selected.normal" = {
            background-color = mkLiteral "var(nord7)";
            text-color = mkLiteral "#2e3440";
          };
          "element-text, element-icon" = {
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "inherit";
          };
          "button" = {
            padding = mkLiteral "6px";
            color = mkLiteral "var(foreground)";
            horizontal-align = mkLiteral "0.5";
            border = mkLiteral "2px 0px 2px 2px";
            border-radius = mkLiteral "4px 0px 0px 4px";
            border-color = mkLiteral "var(foreground)";
          };
          "button selected normal" = {
            border = mkLiteral "2px 0px 2px 2px";
            border-color = mkLiteral "var(foreground)";
          };
        };
    };
  };
}
