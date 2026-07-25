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
  version = "1.103.9";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "cd34d441be2f277221e81672125f73ec3e8cb16d";
    hash = "sha256-KWDuY7P/hoHs7J0n/toh2Kx0vmnEPupmyqvUDWnUZPQ=";
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
