{ buildDunePackage
, fetchFromGitHub
, fetchpatch2
, dune-build-info
, ppx_expect
, uucp
, uunf
, uutf
}:

buildDunePackage (finalAttrs: {
  pname = "omd";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "ocaml-community";
    repo = "omd";
    tag = finalAttrs.version;
    hash = "sha256-PeEWqHgdajSxoi5G4TfyV1S3RRfilYlcttTxQ0xhyE4=";
  };

  patches = [
    (fetchpatch2 {
      name = "0001-omd-footnote-support.patch";
      url = "https://patch-diff.githubusercontent.com/raw/ocaml-community/omd/pull/309.patch";
      hash = "sha256-mlzwQCX9QdIRbKkZbC91f7MzuVTpYDatcvdGdV07B4k=";
    })
  ];

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    dune-build-info
    uucp
    uunf
    uutf
  ];

  doCheck = true;

  checkInputs = [
    ppx_expect
  ];
})
