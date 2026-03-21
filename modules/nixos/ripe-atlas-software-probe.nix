{ lib, ... }:

{ config, pkgs, ... }:

let
  inherit (lib) mkIf mkEnableOption mkPackageOption mkOption types;

  cfg = config.services.ripe-atlas-software-probe;

  pkg = cfg.package.override {
    withUser = cfg.user;
    withGroup = cfg.group;
    withMeasurementUser = cfg.user;
  };

  # override measurements to pick up the same software probe (with correct user
  # in measurement.conf) — the C code reads ATLAS_DATADIR from atlas_path.h
  measurements = pkgs.ripe-atlas-probe-measurements.override {
    ripe-atlas-software-probe = pkg;
  };

  setup = pkgs.writeShellScript "ripe-atlas-setup" ''
    # copy read-only config files from the store to the writable config dir
    for f in mode; do
      [ -f /etc/ripe-atlas/$f ] || cp ${pkg}/etc/ripe-atlas/$f /etc/ripe-atlas/$f
    done
  '';
in
{
  options.services.ripe-atlas-software-probe = {
    enable = mkEnableOption "RIPE Atlas software probe";

    package = mkPackageOption pkgs "ripe-atlas-software-probe" { };

    user = mkOption {
      default = "ripe-atlas";
      description = "user to run the probe and measurement processes as";
      type = types.str;
    };

    group = mkOption {
      default = "ripe-atlas";
      description = "group to run the probe process as";
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    users.groups.${cfg.group} = { };

    users.users.${cfg.user} = {
      group = cfg.group;
      description = "RIPE Atlas probe daemon";
      home = "/var/spool/ripe-atlas";
      createHome = false;
      isSystemUser = true;
    };

    # spool directories matching upstream install-exec-local
    systemd.tmpfiles.rules =
      let
        d = mode: path: "d ${path} ${mode} ${cfg.user} ${cfg.group} -";
        cronDirs = map toString (lib.range 2 20);
      in
      [
        (d "2775" "/var/spool/ripe-atlas")
        (d "2775" "/var/spool/ripe-atlas/data")
        (d "2775" "/var/spool/ripe-atlas/data/new")
        (d "2775" "/var/spool/ripe-atlas/data/oneoff")
        (d "2775" "/var/spool/ripe-atlas/data/out")
        (d "2775" "/var/spool/ripe-atlas/data/out/ooq")
        (d "2775" "/var/spool/ripe-atlas/data/out/ooq10")
        (d "2775" "/var/spool/ripe-atlas/crons")
        (d "2775" "/var/spool/ripe-atlas/crons/main")
        (d "0770" "/etc/ripe-atlas")
      ]
      ++ map (n: d "2775" "/var/spool/ripe-atlas/crons/${n}") cronDirs;

    systemd.services.ripe-atlas-software-probe = {
      description = "RIPE Atlas Software Probe";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = with pkgs; [
        pkg
        measurements
        coreutils
        iproute2
        net-tools
        openssh
        procps
      ];

      environment = {
        HOME = "/var/spool/ripe-atlas";
        ATLAS_MEASUREMENT = "${measurements}/libexec/ripe-atlas/measurement";
        ATLAS_SYSCONFDIR = "/etc/ripe-atlas";
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "/var/spool/ripe-atlas";
        ExecStartPre = "${setup}";
        ExecStart = "${pkg}/sbin/ripe-atlas";
        Restart = "always";
        TimeoutStopSec = 60;
        KillMode = "control-group";

        RuntimeDirectory = "ripe-atlas";
        RuntimeDirectoryMode = "0775";

        AmbientCapabilities = [ "CAP_NET_RAW" ];

        ProtectHome = true;
        PrivateTmp = true;
        RemoveIPC = true;
      };
    };
  };
}
