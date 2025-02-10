{ ocamlPackages }:

ocamlPackages.buildDunePackage {
  pname = "dolmen_lsp";
  inherit (ocamlPackages.dolmen) version src;

  dontDetectOcamlConflicts = true;
  minimalOCamlVersion = "4.02";

  patches = [ ./linol-lwt-6.patch ];

  buildInputs = with ocamlPackages; [
    dolmen
    dolmen_loop
    dolmen_type
    linol
    linol-lwt
    logs
    lsp
  ];

  meta.mainProgram = "dolmenls";
}
