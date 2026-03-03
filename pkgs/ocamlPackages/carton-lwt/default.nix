{ buildDunePackage
, alcotest-lwt
, cachet-lwt
, carton
, digestif
, lwt
}:

buildDunePackage {
  pname = "carton-lwt";

  inherit (carton) version src;

  env.DUNE_CACHE = "disabled";

  propagatedBuildInputs = [
    cachet-lwt
    carton
    lwt
  ];

  doCheck = true;

  checkInputs = [
    alcotest-lwt
    digestif
  ];
}
