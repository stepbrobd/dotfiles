# custom systemd service

{ config
, lib
, pkgs
, inputs
, ...
}:

{
  # disabled, add ysun to input before re-enabling

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

  services.caddy.virtualHosts."ysun.co" = {
    extraConfig = ''
      import common
      reverse_proxy localhost:8000
    '';
    serverAliases = [
      "*.ysun.co"
      "as10779.net"
      "*.as10779.net"
      "churn.cards"
      "*.churn.cards"
      "metaprocessor.org"
      "*.metaprocessor.org"
      "stepbrobd.com"
      "*.stepbrobd.com"
      "xdg.sh"
      "*.xdg.sh"
      "yifei-s.com"
      "*.yifei-s.com"
      "ysun.life"
      "*.ysun.life"
    ];
  };
}
