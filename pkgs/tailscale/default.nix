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
  version = "1.103.84";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "00699abdfbbe0972daa71290203878d828bf4037";
    hash = "sha256-YKncEZgf87JtzWSEbs21sD/y5EoTiKo2mUSJ8GGX01c=";
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
