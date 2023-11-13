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

    taps = [ ];

    brews = [ ];

    casks = [ ];

    masApps = { };
  };
}
