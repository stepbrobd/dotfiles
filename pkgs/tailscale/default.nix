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
  version = "1.103.107";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "9f4fe8b5f2eec188193caa6236fa242d3173a5e1";
    hash = "sha256-Qmrg9v2qMdurIAQoA++/Mv1DPtHQnNXgxZ6hPK2p/yY=";
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
