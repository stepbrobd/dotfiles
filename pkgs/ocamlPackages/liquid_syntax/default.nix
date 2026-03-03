{ buildDunePackage
, base
, calendar
, core
, liquid_ml
, ppx_deriving
, re2
, stdio
}:

buildDunePackage {
  pname = "liquid_syntax";

  inherit (liquid_ml) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    base
    calendar
    core
    ppx_deriving
    re2
    stdio
  ];
}
