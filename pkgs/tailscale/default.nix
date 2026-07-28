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
  version = "1.103.19";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "d0b4d44963d5ea6ce2f8bd312de749dd2e5afa7d";
    hash = "sha256-JUo+olySO9EvCfHH2kMeY++l/Qc3wsDfGolhmz/V/B0=";
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
