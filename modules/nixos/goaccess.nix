{ lib, ... }:

{ config, pkgs, ... }:

{
  systemd.services.goaccess = {
    enable = false;
    description = "goaccess log monitoring";

    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      Type = "simple";

      Restart = "on-failure";
      RestartSec = "10s";

      ExecStart = ''
        ${lib.getExe pkgs.goaccess} \
          --log-format=CADDY \
          --log-file="${config.services.caddy.logDir}/*" \
          --real-time-html \
          --html-refresh=60 \
          --addr=127.0.0.1 \
          --port=7890 \
          --ws-url=wss://${config.networking.hostName}.tail650e82.ts.net:443/access/ws \
          --origin="https://${config.networking.hostName}.tail650e82.ts.net" \
          --geoip-database="${config.services.geoipupdate.settings.DatabaseDirectory}/GeoLite2-City.mmdb"
      '';
      ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";

      DynamicUser = true;
      User = "goaccess";
      Group = "goaccess";
      SupplementaryGroups = [ config.services.caddy.group ];

      NoNewPrivileges = true;
      PrivateDevices = "yes";
      PrivateTmp = true;
      ProtectHome = "read-only";
      ProtectKernelModules = "yes";
      ProtectKernelTunables = "yes";
      ProtectSystem = "strict";
      ReadOnlyPaths = [ config.services.caddy.logDir ];
      ReadWritePaths = [
        "/proc/self"
        "/var/lib/goaccess"
      ];
      StateDirectory = "goaccess";
      SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @privileged @reboot @resources @setuid @swap @raw-io";
      WorkingDirectory = "/var/lib/goaccess";
    };
  };
}
