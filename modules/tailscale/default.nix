# nixpkgs + nix-darwin options

{ config
, lib
, pkgs
, ...
}:

let
  resolver =
    if pkgs.stdenv.isLinux then
      "nameservers"
    else if pkgs.stdenv.isDarwin then
      "dns"
    else
      abort "Unsupported OS";
in
{
  services.tailscale.enable = true;

  networking = {
    "${resolver}" = [
      "100.100.100.100"
      "45.90.28.217"
      "45.90.30.217"
      "2a07:a8c0::d8:664a"
      "2a07:a8c1::d8:664a"
    ];
    search = [ "stepbrobd.com.beta.tailscale.net" ];
  };
}
