{ pkgsPrev
, fetchFromGitHub
, nixVersions
}:

let version = "2.34.3"; in (pkgsPrev.nix-eval-jobs.override { nixComponents = nixVersions.nixComponents_2_34; }).overrideAttrs {
  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nix-eval-jobs";
    tag = "v${version}";
    hash = "sha256-YaVQAgBxWbUBFHXLBLzdUyVvuA/DDw80SEnn9iq0Veo=";
  };
}
