{ buildDunePackage
, base
, core
, liquid_ml
, liquid_syntax
, re2
, stdio
}:

buildDunePackage {
  pname = "liquid_parser";

  inherit (liquid_ml) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    base
    core
    liquid_syntax
    re2
    stdio
  ];
}
