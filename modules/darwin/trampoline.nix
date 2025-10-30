{ lib, ... }:

{ pkgs, ... }:

{
  system.activationScripts.postActivation.text = ''
    ${lib.getExe pkgs.mac-app-util} sync-trampolines "/Applications/Nix Apps" "/Applications/Nix Trampolines"
  '';
}
