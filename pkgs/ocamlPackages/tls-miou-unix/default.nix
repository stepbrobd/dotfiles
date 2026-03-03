{ buildDunePackage
, tls
, crowbar
, hxd
, miou
, mirage-crypto-rng-miou-unix
, ohex
, ptime
, rresult
, x509
}:

buildDunePackage {
  pname = "tls-miou-unix";

  inherit (tls) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    tls
    mirage-crypto-rng-miou-unix
    x509
    miou
  ];

  doCheck = false; # hangs

  checkInputs = [
    crowbar
    hxd
    ohex
    ptime
    rresult
  ];
}
