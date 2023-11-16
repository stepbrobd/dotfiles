# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    global = {
      autoUpdate = false;
      brewfile = true;
      lockfiles = true;
    };

    taps = [
      "homebrew/core"
      "homebrew/cask"
      "homebrew/services"
    ];

    # use home-manager to install cli tools
    brews = [ ];

    casks = [
      "airbuddy"
      "alacritty"
      "aldente"
      "arc"
      "bartender"
      "coconutbattery"
      "discord"
      "hey"
      "obsidian"
      "osu"
      "raycast"
      "slack"
      "zoom"
    ];

    masApps = {
      # utils
      "Apple Configurator" = 1037126344;
      "Authenticator" = 1538761576;
      "Dropover" = 1355679052;
      "Fantastical" = 975937182;
      "Flighty" = 1358823008;
      "iStat Menus" = 1319778037;
      "Parcel" = 639968404;
      "Pixelmator Pro" = 1289583905;
      "Remote Desktop" = 409907375;
      "Tailscale" = 1475387142;
      "TestFlight" = 899247664;
      "Things" = 904280696;
      "The Unarchiver" = 425424353;
      # safari
      "AdGuard" = 1440147259;
      "Kagi" = 1622835804;
      "MyMind" = 1532801185;
      "Noir" = 1592917505;
      # microsoft
      "Microsoft Word" = 462054704;
      "Microsoft Excel" = 462058435;
      "Microsoft PowerPoint" = 462062816;
      # media
      "Infuse" = 1136220934;
      "Macgo Blu-ray Player Pro" = 1403952861;
    };
  };
}
