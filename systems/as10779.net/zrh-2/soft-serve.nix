# nixpkgs options, host specific

{ config
, lib
, pkgs
, ...
}:

{
  # soft-serve git openssh
  networking.firewall.allowedTCPPorts = [ 22 80 443 9418 22222 ];

  # soft-serve takes port 22, rebind openssh to port 22222
  services.openssh.ports = [ 22222 ];

  # soft-serve
  services.soft-serve = {
    enable = true;
    settings = {
      name = "Yifei Sun";
      log_format = "text";
      ssh = {
        listen_addr = "0.0.0.0:22";
        public_url = "ssh://git.ysun.co";
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
        listen_addr = "0.0.0.0:10069";
        public_url = "https://git.ysun.co";
      };
      initial_admin_keys = config.users.users.ysun.openssh.authorizedKeys.keys;
    };
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
      reverse_proxy localhost:10069
    '';
  };
}
