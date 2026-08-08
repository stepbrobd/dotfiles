{ pkgsPrev
, fetchpatch2
}:

pkgsPrev.nix-eval-jobs.overrideAttrs (prev: {
  patches = (prev.patches or [ ]) ++ [
    # FIXME:
    # https://github.com/NixOS/nix-eval-jobs/pull/429
    # temporary patch for https://github.com/NixOS/nix-eval-jobs/issues/430
    (fetchpatch2 {
      url = "https://github.com/NixOS/nix-eval-jobs/commit/ff3b82d0895b68e2a802aa0ab6f726f269c785d8.patch";
      hash = "sha256-U0X00SIBU+GLM4QY4lcaTX4rITQFc651oj2xH2aneOA=";
    })
  ];
})
