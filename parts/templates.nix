{ ... } @ args:

let
  inherit (args.inputs.self.lib) mkDynamicAttrs;
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
