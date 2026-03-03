{ buildDunePackage
, cstruct
, git-kv
, git-net
, logs
, lwt
, mdx
, mimic
, ppx_expect
, yocaml
, yocaml_runtime
}:

buildDunePackage {
  pname = "yocaml_git";

  inherit (yocaml) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    cstruct
    git-kv
    git-net
    lwt
    mimic
    yocaml
    yocaml_runtime
  ];

  doCheck = true;

  nativeCheckInputs = [
    mdx.bin
  ];

  checkInputs = [
    (mdx.override { inherit logs; })
    ppx_expect
  ];
}
