{ buildDunePackage
, fetchzip
, alcotest
, base64
, crowbar
, fmt
, http
, ipaddr
, logs
, ppx_expect
, ppx_sexp_conv
, re
, stringext
, uri
, uri-sexp
,
}:

buildDunePackage (finalAttrs: {
  pname = "cohttp";
  version = "6.2.1";

  src = fetchzip {
    url = "https://github.com/mirage/ocaml-cohttp/releases/download/v${finalAttrs.version}/cohttp-${finalAttrs.version}.tbz";
    hash = "sha256-ARJJriopBU3qm1D3KInEuue9k8T0KEfXZXsDExXoxr4=";
  };

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    base64
    http
    ipaddr
    logs
    ppx_sexp_conv
    re
    stringext
    uri
    uri-sexp
  ];

  doCheck = true;

  checkInputs = [
    alcotest
    crowbar
    fmt
    ppx_expect
  ];
})
