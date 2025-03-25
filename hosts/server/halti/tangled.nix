{ config, inputs, ... }:

{
  imports = [ inputs.tangled.nixosModules.knotserver ];

  sops.secrets.knotserver = {
    owner = "git";
    group = "git";
    mode = "440";
  };

  services.tangled-knotserver = {
    enable = true;
    repo.mainBranch = "master";
    server.hostname = "knot.stepbrobd.com";
    server = {
      secretFile = config.sops.secrets.knotserver.path;
      listenAddr = "127.0.0.1:5443";
      internalListenAddr = "127.0.0.1:5444";
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts.${config.services.tangled-knotserver.server.hostname}.extraConfig = ''
      import common
      reverse_proxy ${config.services.tangled-knotserver.server.listenAddr}
    '';
  };
}
