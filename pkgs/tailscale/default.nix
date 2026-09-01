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

  tsVersion = "1.103.175";
  tsRev = "b25459ab1f3f94f81620e4298d420af3c436a898";
  tsHash = "sha256-x4HXF+ZD8QgCs6RjFJxWNi7f/T9NWNePkM+oL9YDYqU=";

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
