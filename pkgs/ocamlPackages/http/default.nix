{ buildDunePackage
, cohttp
}:

buildDunePackage {
  pname = "http";

  inherit (cohttp) version src;

  env.DUNE_CACHE = "disabled";
}
