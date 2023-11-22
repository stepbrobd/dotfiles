{ config
, lib
, pkgs
, ...
}:

{
  imports = [ ./activation.nix ];

  xdg = {
    enable = true;
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    userDirs = {
      enable = true;
      createDirectories = true;
      extraConfig.XDG_WORKSPACE_DIR = "${config.home.homeDirectory}/Workspace";
    };
  };

  home = {
    username = "ysun";
    homeDirectory =
      if pkgs.stdenv.isLinux
      then lib.mkDefault "/home/ysun"
      else if pkgs.stdenv.isDarwin
      then lib.mkDefault "/Users/ysun"
      else abort "Unsupported OS";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "alacritty";
    BROWSER = "chromium-browser";
  };

  home.packages = with pkgs; [
    cachix
    deadnix
    nix-output-monitor

    flyctl
    google-cloud-sdk

    gitleaks
    github-copilot-cli

    pinentry
    pinentry-curses

    yt-dlp
  ]
  # linux only and when hyprland is enabled
  ++ (lib.optionals (pkgs.stdenv.isLinux && config.wayland.windowManager.hyprland.enable) [
    discord
    obsidian
    osu-lazer-bin
    slack
    smplayer
    spotify
    zoom-us
  ])
  # darwin only
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    cocoapods
    colima
    lima
    reattach-to-user-namespace
  ]);
}
