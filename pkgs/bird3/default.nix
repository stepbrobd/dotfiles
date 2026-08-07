{ pkgsPrev
, fetchpatch2
}:

pkgsPrev.bird3.overrideAttrs (prev: {
  patches = (prev.patches or [ ]) ++ [
    # link quality algo selection
    (fetchpatch2 {
      url = "https://github.com/nickcao/bird/commit/5358b983f8ad6d47df626f1f0a84702133bdd0d6.patch";
      hash = "sha256-inifd1YSR3OW0V4++HcM6JszWx9QMyRvM8JDlaAvkmM=";
    })
    # iface deletion race
    (fetchpatch2 {
      url = "https://github.com/nickcao/bird/commit/b8629f57c1180661704129d13b4c6a388b262c39.patch";
      hash = "sha256-JtB/WFO3WNlCCnccFYB4selgAfQsKr6l+YBob0KSHlQ=";
    })
  ];
})
