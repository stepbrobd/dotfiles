{ config, inputs, ... }:

{
  imports = [ inputs.tangled.nixosModules.knotserver ];

  services.tangled-knotserver = {
    enable = true;
    repo.mainBranch = "master";
    server.hostname = "knot.stepbrobd.com";
    server = {
      secret = ""; # overridden in environment file with key KNOT_SERVER_SECRET
      listenAddr = "127.0.0.1:5443";
      internalListenAddr = "127.0.0.1:5444";
    };
  };

  sops.secrets.knotserver = {
    owner = "git";
    group = "git";
    mode = "440";
  };

  systemd.services.knotserver.serviceConfig.EnvironmentFile = config.sops.secrets.knotserver.path;

  services.caddy = {
    enable = true;
    virtualHosts.${config.services.tangled-knotserver.server.hostname}.extraConfig = ''
      import common
      reverse_proxy ${config.services.tangled-knotserver.server.listenAddr}
    '';
  };
}
