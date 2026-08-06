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
  version = "1.103.77";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "deded79f0e6c5d97ac7efd2b10291f58c800caf6";
    hash = "sha256-OopFSJN4HC1mUOYecUhWg0miKC28fuUjRlAiy6Kyuqc=";
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
