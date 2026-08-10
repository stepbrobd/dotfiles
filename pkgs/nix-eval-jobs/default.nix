{ pkgsPrev
, fetchFromGitHub
}:

pkgsPrev.nix-eval-jobs.overrideAttrs (final: _: {
  version = "2.35.1";
  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nix-eval-jobs";
    tag = "v${final.version}";
    hash = "sha256-EFJnN35L7UieL8zV8qPrpqfdfzztWksY8JYuXF+mr9o=";
  };
})
