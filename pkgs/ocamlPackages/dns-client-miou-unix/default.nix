{ buildDunePackage
, dns-client
, domain-name
, happy-eyeballs
, happy-eyeballs-miou-unix
, ipaddr
, miou
, tls-miou-unix
}:

buildDunePackage {
  pname = "dns-client-miou-unix";

  inherit (dns-client) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    dns-client
    domain-name
    happy-eyeballs
    happy-eyeballs-miou-unix
    ipaddr
    miou
    tls-miou-unix
  ];
}
