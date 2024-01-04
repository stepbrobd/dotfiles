# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  # soft-serve git openssh
  networking.firewall.allowedTCPPorts = [ 22 80 443 9418 10069 ];

  # soft-serve
  services.soft-serve = {
    enable = true;

    settings = {
      name = "Yifei Sun";
      log_format = "text";
      ssh = {
        listen_addr = "0.0.0.0:10069";
        public_url = "ssh://git.ysun.co:10069";
        max_timeout = 3600;
        idle_timeout = 3600;
      };
      git = {
        listen_addr = "0.0.0.0:9418";
        max_timeout = 3600;
        idle_timeout = 3600;
      };
      lfs = {
        enabled = true;
        ssh_enabled = true;
      };
      http = {
        listen_addr = "0.0.0.0:10070";
        public_url = "https://git.ysun.co";
      };
      # resulting yaml has formatting issue
      # initial_admin_keys = config.users.users.ysun.openssh.authorizedKeys.keys;
    };
  };

  systemd.services.soft-serve.environment = {
    SOFT_SERVE_INITIAL_ADMIN_KEYS = lib.concatMapStringsSep "\n" (key: key) config.users.users.ysun.openssh.authorizedKeys.keys;
  };

  # proxy soft-serve to port 80 and 443
  services.caddy = {
    enable = true;
    email = "ysun@hey.com";

    extraConfig = ''
      (common) {
        encode gzip zstd
        header {
          Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
          X-Content-Type-Options "nosniff"
          X-XSS-Protection "1; mode=block"
          -Last-Modified
          -Server
          -X-Powered-By
        }
      }
    '';

    virtualHosts."git.ysun.co".extraConfig = ''
      import common
      reverse_proxy localhost:10070
    '';
  };
}