{ buildDunePackage
, fetchzip
, alcotest
, base64
, bstr
, carton
, carton-git-lwt
, cstruct
, digestif
, emile
, encore
, fmt
, fpath
, hxd
, ke
, logs
, lwt
, mimic
, mirage-kv
, mirage-ptime
, psq
, ptime
, uri
}:

buildDunePackage (finalAttrs: {
  pname = "git-kv";
  version = "0.2.1";

  src = fetchzip {
    url = "https://github.com/robur-coop/git-kv/releases/download/v${finalAttrs.version}/git-kv-${finalAttrs.version}.tbz";
    hash = "sha256-S0pVEBO3SU7W4Je5pQStHg1FerWDkGxro7YDinTTWr4=";
  };

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    base64
    bstr
    carton
    carton-git-lwt
    cstruct
    digestif
    emile
    encore
    fmt
    fpath
    hxd
    ke
    logs
    lwt
    mimic
    mirage-kv
    mirage-ptime
    psq
    ptime
    uri
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];
})
