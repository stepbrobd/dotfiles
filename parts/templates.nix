{ ... } @ args:

let
  inherit (args.outputs.lib) mkDynamicAttrs;
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
