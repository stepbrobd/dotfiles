{
  services.tailscale.extraSetFlags = [
    "--accept-routes"
    "--advertise-exit-node"
    "--advertise-routes=23.161.104.131/32,2602:f590:0::23:161:104:131/128"
    "--snat-subnet-routes=false"
  ];
}
