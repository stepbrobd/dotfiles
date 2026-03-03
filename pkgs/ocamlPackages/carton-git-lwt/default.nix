{ buildDunePackage
, alcotest-lwt
, cachet-lwt
, carton
, carton-lwt
, digestif
}:

buildDunePackage {
  pname = "carton-git-lwt";

  inherit (carton) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    cachet-lwt
    carton
    carton-lwt
    digestif
  ];

  doCheck = true;

  checkInputs = [
    alcotest-lwt
  ];
}
