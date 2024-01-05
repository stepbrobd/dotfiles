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
    mimeApps = rec {
      enable = true;
      associations.added = defaultApplications;
      defaultApplications = {
        "inode/directory" = [ "spacedrive.desktop" ];

        "application/pdf" = [ "zathura.desktop" ];
        "application/x-pdf" = [ "zathura.desktop" ];

        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];

        "x-scheme-handler/discord" = [ "discord.desktop" ];

        "x-scheme-handler/slack" = [ "slack.desktop" ];
      };
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
    TERM = "alacritty";
    GOROOT = "${config.xdg.dataHome}/go";
    GOPATH = "${config.xdg.dataHome}/go/path";
  };

  home.packages = with pkgs; [
    nix-output-monitor
    pinentry
    pinentry-curses
    ripgrep
  ]
  # linux only and when hyprland is enabled
  ++ (lib.optionals (pkgs.stdenv.isLinux && config.wayland.windowManager.hyprland.enable) [
    beeper
    cider
    discord
    flyctl
    gitleaks
    google-cloud-sdk
    obsidian
    osu-lazer-bin
    slack
    smplayer
    spacedrive
    spotify
    terraform
    yt-dlp
    zoom-us
  ])
  # darwin only
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    cocoapods
    colima
    flyctl
    gitleaks
    google-cloud-sdk
    lima
    reattach-to-user-namespace
    terraform
    yt-dlp
  ]);
}
