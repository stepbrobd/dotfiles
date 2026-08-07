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
  version = "1.103.80";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "a265908a72ddab93de230a1b1495e252eefa9aee";
    hash = "sha256-HgV5z4N8aqhzZPt2+meI+oVmoYbDgmRF+99B3Qj2uJE=";
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
