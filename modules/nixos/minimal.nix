{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ prometheus tailscale ];
  services.prometheus.enable = true;
}
