{ buildDunePackage
, base
, base64
, calendar
, core
, liquid_ml
, liquid_parser
, liquid_syntax
, re2
, sha
, stdio
}:

buildDunePackage {
  pname = "liquid_std";

  inherit (liquid_ml) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    base
    base64
    calendar
    core
    liquid_parser
    liquid_syntax
    re2
    sha
    stdio
  ];
}
