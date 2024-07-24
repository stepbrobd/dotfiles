{ lib, ... } @ args:

let
  inherit (lib) mkDynamicAttrs;
in
{
  flake.templates = mkDynamicAttrs {
    dir = ../templates;
    fun = path: {
      description = "template for ${path}";
      path = ../templates/. + "/${path}";
    };
  };
}
