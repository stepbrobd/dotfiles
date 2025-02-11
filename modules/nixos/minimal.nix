{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ tailscale ];
  # services.prometheus.enable = true;
}
