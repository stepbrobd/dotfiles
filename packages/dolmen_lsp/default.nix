# remove after nixpkgs#380805 is merged

{ ocamlPackages }:

ocamlPackages.buildDunePackage {
  pname = "dolmen_lsp";
  inherit (ocamlPackages.dolmen) version src;

  minimalOCamlVersion = "4.02";

  patches = [ ./linol-lwt-6.patch ];

  buildInputs = with ocamlPackages; [
    dolmen
    dolmen_loop
    dolmen_type
    linol
    linol-lwt
    logs
  ];

  meta.mainProgram = "dolmenls";
}
