{ buildDunePackage
, fetchzip
, dune-configurator
, pkgs
}:

buildDunePackage (finalAttrs: {
  pname = "oniguruma";
  version = "0.1.2";

  src = fetchzip {
    url = "https://github.com/alan-j-hu/ocaml-oniguruma/releases/download/${finalAttrs.version}/oniguruma-${finalAttrs.version}.tbz";
    hash = "sha256-GIIFFy3mxmNn4tRT4aZ/lz40f0NAaiT7IYoOPeyflY4=";
  };

  env.DUNE_CACHE = "disabled";

  buildInputs = [ dune-configurator ];

  propagatedBuildInputs = [
    pkgs.oniguruma
  ];

  doCheck = true;
})
