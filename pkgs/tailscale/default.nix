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
  version = "1.103.96";

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = "d200b3f18f0ee4cff1f6819a78a9fe8e6a7367f2";
    hash = "sha256-fzR9ZU7hZyld2IxeAxC+g87BPE8RvWvEI3T11Jdm4vM=";
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
