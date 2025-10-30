{ lib, ... }:

{ pkgs, ... }:

{
  home.activation.trampolineApps = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    fromDir="$HOME/Applications/Home Manager Apps"
    toDir="$HOME/Applications/Home Manager Trampolines"
    ${lib.getExe pkgs.mac-app-util} sync-trampolines "$fromDir" "$toDir"
  '';
}
