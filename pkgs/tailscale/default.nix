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
  version = "1.103.54";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "47e52e5f1f1d23d8e1789f149f61cb144855a2b9";
    hash = "sha256-oAcLTR9Tpa0BamW0E71H8Nhjpyn0zb2o46REKhXMu44=";
  };

  vendorHash = "sha256-SeMc9PQ3acMyeFDVQr/lretHtGrBJxhM4sgBg2l4t1w=";

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
