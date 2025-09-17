{ inputs, ... }:

{ ... }:

{
  imports = [ inputs.tsnsrv.nixosModules.default ];

  services.tsnsrv.defaults = {
    # ...
  };
}
