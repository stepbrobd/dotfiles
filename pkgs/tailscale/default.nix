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
  version = "1.103.87";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "e592a0c36398be8a435d1cc9e039c732c540051c";
    hash = "sha256-jJff5Hujqb3byO7VMkLUKRPKZKMA8B4AQoTbVA5nLfc=";
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
