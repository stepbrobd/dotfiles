{ config
, lib
, pkgs
, ...
}:

{
  imports = [ ./activation.nix ];

  xdg.userDirs.extraConfig.XDG_WORKSPACE_DIR = "${config.home.homeDirectory}/Workspace";

  home = {
    username = "ysun";
    homeDirectory =
      if pkgs.stdenv.isLinux
      then "/home/ysun"
      else if pkgs.stdenv.isDarwin
      then "/Users/ysun"
      else abort "Unsupported OS";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "alacritty";
    BROWSER = "chromium --enable-features=UseOzonePlatform --ozone-platform=wayland";
  };

  home.packages = with pkgs; [
    cachix
    nix-output-monitor

    gitleaks
    github-copilot-cli

    pinentry
    pinentry-curses

    obsidian

    discord
    osu-lazer-bin
  ]
  # linux only
  ++ (lib.optionals pkgs.stdenv.isLinux [
    deadnix

    smplayer
  ])
  # darwin only
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    lima
    colima

    aldente
    coconutbattery
    bartender
    airbuddy
    raycast
  ]);
}
