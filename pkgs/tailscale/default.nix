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
  goVersion = "1.26.6";
  goRev = "7275f792d406d3c386cc807937a45a4a7b699d42";
  goHash = "sha256-X5BJTH4gdjaww4wQZUQ8b2Yy0xztHYVPzsg/YXfmCPs=";

  tsVersion = "1.103.141";
  tsRev = "86e5d3873aa96403d42e35ddd9247834c309691b";
  tsHash = "sha256-lxj/I3DJOhVzoG4G5DhizjOdao8sSzxgd/DMX2vnbEE=";

  vendorHash = "sha256-zhqsqZG3LyclwUjtj9b3EbhabiV8a4L+OS6OVTNmdF4=";
in

(pkgsPrev.tailscale.override {
  buildGoModule = pkgsPrev.buildGoModule.override {
    go = pkgsPrev.go.overrideAttrs (prev: {
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
