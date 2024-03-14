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
    GOROOT = "${pkgs.go}/share/go";
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/pkg/mod";
  };

  home.packages = with pkgs; [
    nix-output-monitor
    ripgrep
  ]
  # linux only and when hyprland is enabled
  ++ (lib.optionals (pkgs.stdenv.isLinux && config.wayland.windowManager.hyprland.enable) [
    beeper
    cider
    discord
    gitleaks
    obsidian
    osu-lazer-bin
    pinentry-all
    slack
    smplayer
    spacedrive
    spotify
    yt-dlp
    zoom-us
  ])
  # darwin only
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    cocoapods
    gitleaks
    pinentry_mac
    reattach-to-user-namespace
    spotify
    yt-dlp
  ]);
}
