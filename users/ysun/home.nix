{ config
, lib
, pkgs
, osConfig
, ...
}:

{
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
        "x-scheme-handler/discord" = [ "discord.desktop" ];
        "x-scheme-handler/slack" = [ "slack.desktop" ];
      };
    };
  };

  home = {
    username = "ysun";
    homeDirectory =
      if pkgs.stdenv.isLinux then
        lib.mkDefault "/home/ysun"
      else if pkgs.stdenv.isDarwin then
        lib.mkDefault "/Users/ysun"
      else
        abort "Unsupported OS";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "alacritty";
    GOROOT = "${pkgs.go}/share/go";
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/pkg/mod";
  };

  home.packages = with pkgs; [
    comma
    curl
    jq
    nixvim
    nix-output-monitor
    ripgrep
    wget
  ]
  # linux only and when kde plasma is enabled
  ++ (lib.optionals (pkgs.stdenv.isLinux && osConfig.services.desktopManager.plasma6.enable) [
    beeper
    cider
    discord
    gitleaks
    llvm-bolt
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
    flyctl
    gitleaks
    llvm-bolt
    pinentry_mac
    # reattach-to-user-namespace
    spotify
    yt-dlp
  ]);

  home.activation.hushlogin = lib.hm.dag.entryAnywhere ''
    $DRY_RUN_CMD touch ${config.home.homeDirectory}/.hushlogin
  '';
}
