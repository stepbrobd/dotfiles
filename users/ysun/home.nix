{ config
, inputs
, lib
, osConfig
, pkgs
, ...
}:

let
  nixvim = inputs.self.packages.${pkgs.stdenv.system}.nixvim;
in
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
    vim
    nix-output-monitor
    ripgrep
    wget
  ]
  # linux only and when kde plasma is enabled
  ++ (lib.optionals (pkgs.stdenv.isLinux && osConfig.services.desktopManager.enabled != null) [
    cfspeedtest
    cider
    discord
    gitleaks
    go
    neovide
    nixvim
    obsidian
    (osu-lazer-bin.override { nativeWayland = true; })
    pat
    pinentry-all
    slack
    smplayer
    spacedrive
    yt-dlp
    zoom-us
  ])
  # darwin only
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    cfspeedtest
    cocoapods
    flyctl
    gitleaks
    go
    nixvim
    pat
    pinentry_mac
    # reattach-to-user-namespace
    yt-dlp
  ]);

  home.activation.hushlogin = lib.hm.dag.entryAnywhere ''
    $DRY_RUN_CMD touch ${config.home.homeDirectory}/.hushlogin
  '';
}
