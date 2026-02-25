# drop src override after https://github.com/nixos/nixpkgs/pull/494140 hits unstable

{ lib
, pkgsPrev
, fetchFromGitHub
}:

pkgsPrev.calibre-web.overridePythonAttrs (prev: {
  version = "0.6.27-unstable-2026-02-22";

  src = fetchFromGitHub {
    owner = "janeczku";
    repo = "calibre-web";
    rev = "5e48a64b1517574c31cf667be8c45bcd05cd0904";
    hash = "sha256-OgaU+Kj24AzalMM8dhelJz1L8akadJoJApQw3q8wbCc=";
  };

  patches = prev.patches ++ [ ./header-and-stats.patch ];
  dependencies =
    prev.dependencies
    ++ lib.flatten (with prev.optional-dependencies; [ comics kobo ldap metadata ]);
})
