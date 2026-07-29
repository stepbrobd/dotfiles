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
  version = "1.103.25";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "5a41b799559cbff2aeeefd380f2e7c4b399e8be2";
    hash = "sha256-BhW6DKz2T+RrDiONoaqiUnd2Dq5xOF2T1RbTxBpIplM=";
  };

  vendorHash = "sha256-5ClQ5fSyEHUlhPtZI0ir8ddQRXSnqOG5VIJ3KjWtXmw=";

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
