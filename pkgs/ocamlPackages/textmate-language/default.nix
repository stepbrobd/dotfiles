{ buildDunePackage
, fetchzip
, alcotest
, ezjsonm
, oniguruma
, plist-xml
, yojson
}:

buildDunePackage (finalAttrs: {
  pname = "textmate-language";
  version = "0.4.0";

  src = fetchzip {
    url = "https://github.com/alan-j-hu/ocaml-textmate-language/releases/download/${finalAttrs.version}/textmate-language-${finalAttrs.version}.tbz";
    hash = "sha256-w3GjB9/RUvXAJgchYFlws623ijwk/L7xFuYYZq8kzMo=";
  };

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    oniguruma
  ];

  doCheck = true;

  checkInputs = [
    alcotest
    ezjsonm
    plist-xml
    yojson
  ];
})
