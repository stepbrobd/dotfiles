# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  # tracking: nix-darwin#970
  # macOS Sequoia replaces _nixbld{1,2,3,4} with system users
  ids.uids.nixbld = lib.mkForce 30000;
  nix.configureBuildUsers = true;

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

    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };

  security.pam.enableSudoTouchIdAuth = true;
}
