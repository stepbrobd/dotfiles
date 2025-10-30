{ lib
, inputs
, stdenv
}:

let
  noCheckForSbcl257Plz = p:
    if lib.isDerivation p && p.name == "sbcl" && p.version == "2.5.7" then
      p.overrideAttrs
        (prev: {
          doCheck = false;
          nativeBuildInputs = if prev ? nativeBuildInputs then lib.map noCheckForSbcl257Plz prev.nativeBuildInputs else [ ];
          buildInputs = if prev ? buildInputs then lib.map noCheckForSbcl257Plz prev.buildInputs else [ ];
        })
    else p;
in
noCheckForSbcl257Plz inputs.trampoline.packages.${stdenv.hostPlatform.system}.default
