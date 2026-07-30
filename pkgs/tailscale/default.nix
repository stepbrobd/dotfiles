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
  version = "1.103.31";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "e17e38c29061c8e457cc93d50e539700588b61c8";
    hash = "sha256-AY/yEoiFWqMxpHl3XMF5ISW6fvEu58zGqiqmwrmijeA=";
  };

  vendorHash = "sha256-YUibqJuLztzc74AD13Xu1on5ECbF7qbF4h3B2FPhuVI=";

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
