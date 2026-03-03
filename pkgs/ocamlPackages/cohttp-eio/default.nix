{ buildDunePackage
, alcotest
, ca-certs
, cohttp
, eio
, eio_main
, fmt
, ipaddr
, logs
, ppx_expect
, ppx_here
, ptime
, tls-eio
, uri
}:

buildDunePackage {
  pname = "cohttp-eio";

  inherit (cohttp) version src;

  __darwinAllowLocalNetworking = true;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    cohttp
    eio
    fmt
    ipaddr
    logs
    ptime
    uri
  ];

  doCheck = true;

  checkInputs = [
    alcotest
    ca-certs
    eio_main
    ppx_expect
    ppx_here
    tls-eio
  ];
}
