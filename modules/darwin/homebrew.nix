# { pkgs, ... }:

{
  # environment.systemPackages = [ pkgs.mas ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    global = {
      autoUpdate = true;
      brewfile = true;
      lockfiles = true;
    };

    taps = [
      # my own taps
      "stepbrobd/tap"
      # universal audio
      "resonative/proaudio"
      # sonarworks soundid
      "lyraphase/av-casks"

      # third-party taps
      "nextfire/tap"
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
      # my own casks
      "stepbrobd/tap/opentabletdriver"
      # universal audio
      "resonative/proaudio/ua-connect"
      # sonarworks soundid
      "lyraphase/av-casks/soundid-reference"

      "airbuddy"
      "aldente"
      "betterdisplay"
      "container"
      "discord"
      "element"
      "google-chrome"
      "hey-desktop"
      "jordanbaird-ice"
      "lulu"
      "notchnook"
      "obs"
      "orion"
      "osu"
      "signal"
      "slack"
      "yubico-authenticator"
      "zoom"
      "zotero"

      # caldigit
      "caldigit-docking-utility"
      "caldigit-thunderbolt-charging"
    ];

    masApps = {
      # utils
      "Apple Configurator" = 1037126344;
      "Craft" = 1487937127;
      "Dropover" = 1355679052;
      "Folder Preview" = 6698876601;
      "iMazing Profile Editor" = 1487860882;
      "Reeder" = 1529448980;
      "Flighty" = 1358823008;
      "iStat Menus" = 1319778037;
      "Parcel" = 639968404;
      "Passepartout" = 1433648537;
      "Pieoneer" = 6739781207;
      "Pixelmator Pro" = 1289583905;
      "Remote Desktop" = 409907375;
      "ServerCat" = 1501532023;
      "Tailscale" = 1475387142;
      "The Unarchiver" = 425424353;
      # safari
      "AdGuard" = 1440147259;
      "Kagi" = 1622835804;
      "Noir" = 1592917505;
      "StopTheMadness" = 6471380298;
      "Vimari" = 1480933944;
      # media
      "Infuse" = 1136220934;
      "Macgo Blu-ray Player Pro" = 1403952861;
      # iwork
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
    };
  };
}
