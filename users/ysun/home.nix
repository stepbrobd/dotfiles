{ config
, lib
, pkgs
, ...
}:

{
  imports = [ ./activation.nix ];

  home = {
    username = "ysun";
    homeDirectory =
      if pkgs.stdenv.isLinux
      then "/home/ysun"
      else if pkgs.stdenv.isDarwin
      then "/Users/ysun"
      else abort "Unsupported OS";
  };

  home.packages = with pkgs; [
    cachix
    nix-output-monitor
    gitleaks
    github-copilot-cli
  ]
  # linux only
  ++ (lib.optionals pkgs.stdenv.isLinux [
  ])
  # darwin only
  ++ (lib.optionals pkgs.stdenv.isDarwin [
    # virtualization
    lima
    colima
    # battery
    aldente
    coconutbattery
    # status bar
    bartender
    # bluetooth device manager
    airbuddy
    # productivity
    raycast
    obsidian
    # entertainment
    discord
    osu-lazer-bin
  ]);
}
