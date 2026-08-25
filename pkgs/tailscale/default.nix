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

  tsVersion = "1.103.148";
  tsRev = "65d222674245e22bac64bb31a5c39cc3de2f9251";
  tsHash = "sha256-GZ9ej3zl99TbcB+9ogqfOupZVAN7qJ1Kw5Eh0Q7d6aM=";

  vendorHash = "sha256-h3KPqXE1Wvl1nfUmus0zWowaiqBIxz6eJT/+dIBEkOM=";
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
