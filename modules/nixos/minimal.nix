{ inputs, ... }:

{
  imports = with inputs.self.nixosModules; [ fail2ban tailscale ];
  # services.prometheus.enable = true;
}
