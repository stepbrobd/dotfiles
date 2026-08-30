# TODO: drop after https://github.com/NixOS/nixpkgs/pull/558036
{ lib
, tree-sitter
, fetchFromGitHub
}:

let
  version = "0.2.0";
in
(tree-sitter.buildGrammar {
  language = "rocq";
  inherit version;
  src = fetchFromGitHub {
    owner = "aruzdh";
    repo = "tree-sitter-rocq";
    rev = "v${version}";
    hash = "sha256-RZ7BGoBrHi+2Sn727L/6LEt/jh4+WphFIh1DP4Ul1Jo=";
  };
  meta = {
    description = "Tree-sitter grammar for Rocq";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
  };
}).overrideAttrs {
  passthru.autobump = true;
  fixupPhase = ''
    mkdir -p $out/queries/rocq
    mv $out/queries/*.scm $out/queries/rocq/
  '';
}
