# custom systemd service

{ config
, lib
, pkgs
, ...
}:

{
  systemd.services.soft-serve = {
    enable = true;
    description = "Soft Serve";
    documentation = [ "https://github.com/charmbracelet/soft-serve" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = { };
  };
}
