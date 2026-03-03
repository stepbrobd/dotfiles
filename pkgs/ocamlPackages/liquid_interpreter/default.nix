{ buildDunePackage
, base
, core
, liquid_ml
, liquid_parser
, liquid_std
, liquid_syntax
, re2
, stdio
}:

buildDunePackage {
  pname = "liquid_interpreter";

  inherit (liquid_ml) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    base
    core
    liquid_parser
    liquid_std
    liquid_syntax
    re2
    stdio
  ];
}
