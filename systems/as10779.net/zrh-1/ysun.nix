# custom systemd service

{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:

{
  systemd.services.ysun = {
    enable = true;
    description = "Yifei Sun's personal website";
    documentation = [ "https://github.com/stepbrobd/ysun" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${inputs.ysun.packages.${config.nixpkgs.hostPlatform.system}.default}/bin/ysun";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
