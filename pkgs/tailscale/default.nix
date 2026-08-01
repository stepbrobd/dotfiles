{ lib
, pkgsPrev
, fetchFromGitHub
, writeShellApplication
, nix-prefetch-github
, coreutils
, git
, gnused
, jq
}:

pkgsPrev.tailscale.overrideAttrs (prev: {
  version = "1.103.65";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "d645114dd4c96543c08abe410ef774f8368738d7";
    hash = "sha256-0uP3nsq0GQTHJSdwaH+DERWG69/tQtywylcVTVivyaY=";
  };

  vendorHash = "sha256-kvfs58mc2bwjDSTeEAdKh+bCPc3aP/5/6qG5YEHgS18=";

  passthru = (prev.passthru or { }) // {
    autobump = true;
    updateScript = [
      (lib.getExe (writeShellApplication {
        name = "tailscale-updater";
        text = lib.readFile ./update.sh;
        runtimeInputs = [
          coreutils
          git
          gnused
          jq
          nix-prefetch-github
        ];
      }))
    ];
  };
})
