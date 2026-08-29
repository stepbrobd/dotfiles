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

let
  goVersion = "1.27.0";
  goRev = "7f1bd87de70d92fc612426e787e7dfb8275c07d6";
  goHash = "sha256-mn1snbErBYXkxaR/IQnmGVDOdfTaP+tBgHZB4UFaHW8=";

  tsVersion = "1.103.161";
  tsRev = "33af330c8ed8a1cb02530eaf70d9179f9656db2c";
  tsHash = "sha256-fpb9H6fYhRdPF6MZSiV8DybDBS9MhsxQ4MCEFZRj8O8=";

  vendorHash = "sha256-h3KPqXE1Wvl1nfUmus0zWowaiqBIxz6eJT/+dIBEkOM=";
in

(pkgsPrev.tailscale.override {
  buildGoModule = pkgsPrev.buildGoModule.override {
    go = pkgsPrev."go_1_${lib.versions.minor goVersion}".overrideAttrs (prev: {
      version = goVersion;

      src = fetchFromGitHub {
        owner = "tailscale";
        repo = "go";
        rev = goRev;
        hash = goHash;
      };

      postPatch = (prev.postPatch or "") + ''
        substituteInPlace src/runtime/debug/mod.go \
          --replace-fail "TAILSCALE_GIT_REV_TO_BE_REPLACED_AT_BUILD_TIME" "${goRev}"
      '';
    });
  };
}).overrideAttrs (prev: {
  version = tsVersion;

  src = fetchFromGitHub {
    owner = "tailscale";
    repo = "tailscale";
    rev = tsRev;
    hash = tsHash;
  };

  inherit vendorHash;

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
