{ lib, ... }:

{ config, pkgs, ... }:

{
  config = lib.mkIf config.services.calibre-web.enable {
    services.calibre-web = {
      package = pkgs.calibre-web.overridePythonAttrs (prev: {
        patches = prev.patches ++ [ ./header-and-stats.patch ];
        dependencies =
          prev.dependencies
          ++ lib.flatten (with prev.optional-dependencies; [ comics kobo ldap metadata ]);
      });

      listen.ip = "127.0.0.1";
      listen.port = 8083;

      options = {
        enableBookUploading = true;
        enableBookConversion = true;
        calibreLibrary = "/var/lib/calibre-web/books";
      };
    };

    # https://github.com/nixos/nixpkgs/issues/441359
    # https://github.com/nixos/nixpkgs/pull/441487
    systemd.services.calibre-web.serviceConfig.environment = lib.mkForce "";
    systemd.services.calibre-web.environment.CACHE_DIR = "/var/cache/calibre-web";

    services.caddy = {
      enable = true;
      virtualHosts."read.ysun.co".extraConfig =
        with config.services.calibre-web.listen ;
        ''
          import common
          import csp
          reverse_proxy ${ip}:${lib.toString port}
        '';
    };
  };
}
