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

      dataDir = "/var/lib/calibre-web";
      options = {
        enableBookUploading = true;
        enableBookConversion = true;
        calibreLibrary = "${config.services.calibre-web.dataDir}/books";
      };
    };

    # fix book cover cache dir in /nix/store/ error
    # see cps/constants.py and cps/fs.py
    systemd.services.calibre-web = {
      serviceConfig.CacheDirectory = "/var/cache/calibre-web";
      environment.CACHE_DIR = "/var/cache/calibre-web";
    };

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
