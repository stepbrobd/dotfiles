{ tree-sitter
, fetchFromGitHub
}:

(tree-sitter.buildGrammar {
  language = "coq";
  version = "0-unstable-2025-08-17";
  src = fetchFromGitHub {
    owner = "lamg";
    repo = "tree-sitter-rocq";
    rev = "051e6cf9c2c37eadc447551097d6ea9a523e8afd";
    hash = "sha256-aAFwjcMxe5ksCYEpSBORgajgSchREMIXeFLGLsRToR0=";
  };
}).overrideAttrs {
  fixupPhase = ''
    mkdir -p $out/queries/coq
    mv $out/queries/*.scm $out/queries/coq/
  '';
}
