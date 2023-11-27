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
    cider
    discord
    flyctl
    gitleaks
    google-cloud-sdk
    obsidian
    osu-lazer-bin
    slack
    smplayer
    spotify
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
    yt-dlp
  ]);
}
