{ pkgs, ... }:

{
  nix.enable = true;

  environment.systemPackages = [ pkgs.iproute2mac ];

  system.defaults = {
    alf = {
      allowdownloadsignedenabled = 1;
      allowsignedenabled = 1;
      globalstate = 1;
      loggingenabled = 0;
      stealthenabled = 0;
    };

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

  security.pam.enableSudoTouchIdAuth = true;
}
