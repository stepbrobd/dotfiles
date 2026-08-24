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

  tsVersion = "1.103.143";
  tsRev = "ed7d521caedb5c445db9641461169d6023333a27";
  tsHash = "sha256-ASAGqqBYdZmYGRrKK0/XF4ra0cxKh0qzmTB/3b8KM6M=";

  vendorHash = "sha256-5In+C38s6liec6DYKUjDz+Dv1sJ9xe6OcWMoJ/lyocw=";
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
