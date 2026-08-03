{ lib, ... }:

{ pkgs, ... }:

{
  home.sessionVariables = {
    COLORTERM = "truecolor";
  };

  programs.alacritty = {
    enable = true;

    settings = {
      env.TERM = "alacritty";

      window = {
        startup_mode = "Windowed";
        padding = {
          x = 4;
          y = 4;
        };
        decorations =
          if pkgs.stdenv.isLinux then
            lib.mkDefault "None"
          else if pkgs.stdenv.isDarwin then
            lib.mkDefault "Buttonless"
          else
            abort "Unsupported OS";
      };

      keyboard.bindings = [
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "V";
          mods = "Control|Shift";
          action = "Paste";
        }
        {
          key = "Up";
          mods = "Control|Shift";
          action = "ScrollPageUp";
        }
        {
          key = "Down";
          mods = "Control|Shift";
          action = "ScrollPageDown";
        }
      ];
    };
  };
}
