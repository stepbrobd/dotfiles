{ buildDunePackage
, fetchFromGitHub
, alcotest
, base
, core
, liquid_interpreter
, liquid_parser
, liquid_std
, liquid_syntax
, re2
, stdio
}:

buildDunePackage (finalAttrs: {
  pname = "liquid_ml";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "benfaerber";
    repo = "liquid-ml";
    tag = finalAttrs.version;
    hash = "sha256-GvzSVu/84tqsXb0qS+xf7Jda95TOCHaCJv43Li2ZLyA=";
  };

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    base
    core
    liquid_interpreter
    liquid_parser
    liquid_std
    liquid_syntax
    re2
    stdio
  ];

  doCheck = true;

  checkInputs = [
    alcotest
  ];
})
