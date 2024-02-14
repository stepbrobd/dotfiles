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
      "nextfire/tap"
      # "homebrew/core"
      # "homebrew/cask"
      # "homebrew/cask-versions"
      "homebrew/services"
    ];

    brews = [
      # apple music discord rich presence
      # requires deno readline sqlite
      {
        name = "apple-music-discord-rpc";
        start_service = true;
        restart_service = "changed";
      }
      "deno"
      "readline"
      "sqlite"
    ];

    casks = [
      "airbuddy"
      "aldente"
      "amie"
      "arc"
      "bartender"
      "beeper"
      "cleanmymac"
      "coconutbattery"
      "discord"
      # "firefox-developer-edition"
      # "hey"
      "obsidian"
      "orbstack"
      "osu"
      "raycast"
      "slack"
      "spacedrive"
      "wireshark"
      "yubico-yubikey-manager"
      "zoom"
    ];

    masApps = {
      # utils
      "Apple Configurator" = 1037126344;
      "Authenticator" = 1538761576;
      "Dropover" = 1355679052;
      # "Fantastical" = 975937182;
      "Flighty" = 1358823008;
      "iStat Menus" = 1319778037;
      "Parcel" = 639968404;
      "Pixelmator Pro" = 1289583905;
      "Remote Desktop" = 409907375;
      "ServerCat" = 1501532023;
      "Tailscale" = 1475387142;
      # "Things" = 904280696;
      "The Unarchiver" = 425424353;
      "Xcode" = 497799835;
      # safari
      "AdGuard" = 1440147259;
      # "Bitwarden" = 1352778147;
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
