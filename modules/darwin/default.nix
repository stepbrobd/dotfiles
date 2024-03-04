# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 48;
      largesize = 64;
      minimize-to-application = true;
      show-recents = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = false;
      CreateDesktop = false;
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };
}
