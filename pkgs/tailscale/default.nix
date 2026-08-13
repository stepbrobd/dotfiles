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
  version = "1.103.104";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "fd07b9a2b679898035e8a9f202e751302e6338c3";
    hash = "sha256-rNJNjhrWF2Z+RCyLo1s2nBEq43OtOHUsuISnKz7dtJE=";
  };

  vendorHash = "sha256-HmYk03X3wjmGtuFDLKgJGF7/8okbsjMB4S9G9DaXMJ0=";

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
