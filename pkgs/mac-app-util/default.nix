{ inputs
, stdenv
, pkgs
}:

inputs.trampoline.packages.${stdenv.hostPlatform.system}.default.overrideAttrs {
  doCheck = false;
  buildInputs = [
    (pkgs.sbcl_2_5_5.withPackages (_: with _; [
      alexandria
      cl-interpol
      cl-json
      inferior-shell
      str
      trivia
    ]))
  ];
}
