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
  version = "1.103.108";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "ab0489912f699aba2a88a27878f6c9df09c55e11";
    hash = "sha256-743mDDfn59s8LalariSjUFGySLFnOhKbAXxJgKqacB4=";
  };

  vendorHash = "sha256-uwo3oCFKfjRXVEx/xXT2zQrS2pYX32vhVaOAR5NsBOM=";

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
