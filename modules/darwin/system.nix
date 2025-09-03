{ lib, ... }:

{ pkgs, ... }:

{
  # required by nix-darwin system activation
  # remove after nix-darwin migrated modules either to `users.users` namespace
  # or moved to home-manager
  system.primaryUser = "ysun";

  nix.enable = true;

  services.ntpd-rs = {
    enable = true;
    settings.source = lib.map
      (s: {
        mode = "nts";
        address = s;
        ntp-version = "auto";
      })
      [
        "time.ysun.co"
        "time.cloudflare.com"
        "virginia.time.system76.com"
        "ohio.time.system76.com"
        "oregon.time.system76.com"
        "paris.time.system76.com"
        "brazil.time.system76.com"
        "ntppool1.time.nl"
        "ntppool2.time.nl"
      ];
  };


  environment.systemPackages = [ pkgs.iproute2mac ];

  networking.applicationFirewall = {
    enable = true;
    blockAllIncoming = false;
    enableStealthMode = false;
    allowSigned = true;
    allowSignedApp = true;
  };

  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 64;
      largesize = 64;
      minimize-to-application = true;
      show-recents = true;
      mru-spaces = false;
      wvous-bl-corner = 1;
      wvous-br-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = false;
      CreateDesktop = false;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    loginwindow = {
      # https://mynixos.com/nix-darwin/options/system.defaults.loginwindow
      GuestEnabled = false;
    };

    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;
}
