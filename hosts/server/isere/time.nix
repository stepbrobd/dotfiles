{ lib, pkgs, ... }:

{
  systemd.services."serial-getty@ttyAMA0".enable = false;

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", KERNEL=="ttyAMA0", OWNER="root", GROUP="gpsd", MODE="0666"
    SUBSYSTEM=="pps", KERNEL=="pps0", OWNER="root", GROUP="gpsd", MODE="0666"
  '';

  srvos.boot.consoles = lib.mkForce [ ];
  boot.kernelParams = [ "nohz=off" ];
  boot.kernelModules = [ "pps-gpio" "pps-ldisc" ];
  hardware.raspberry-pi.config.all = {
    options.force_turbo = {
      enable = true;
      value = 1;
    };

    base-dt-params = {
      uart0 = {
        enable = true;
        value = "on";
      };
      i2c_arm = {
        enable = true;
        value = "on";
      };
      rtc = {
        enable = true;
        value = "off";
      };
    };

    dt-overlays = {
      uart0-pi5 = {
        enable = true;
        params = { };
      };
      i2c-rtc = {
        enable = true;
        params = {
          rv3028.enable = true;
          addr = {
            enable = true;
            value = "0x52";
          };
        };
      };
      pps-gpio = {
        enable = true;
        params.gpiopin = {
          enable = true;
          value = 18;
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [ i2c-tools gpsd pps-tools ];

  services.gpsd = {
    enable = true;
    nowait = true;
    readonly = false;
    devices = [ "/dev/ttyAMA0" "/dev/pps0" ];
    extraArgs = [
      "-r"
      "-s"
      "115200"
    ];
  };

  services.ntpd-rs.server = {
    enable = true;
    domain = "time.ysun.co";
  };

  services.ntpd-rs.settings.source = [
    {
      mode = "sock";
      path = "/run/ntpd-rs/chrony.ttyAMA0.sock";
      precision = 0.0000001;
    }
    {
      mode = "pps";
      path = "/dev/pps0";
      precision = 0.0000001;
    }
  ];

  # https://docs.ntpd-rs.pendulum-project.org/guide/gps-pps/
  systemd.services.gpsd-socket-shim = {
    description = "gpsd socket shim for ntpd-rs";
    documentation = [ "https://github.com/pendulum-project/ntpd-rs" ];

    after = [ "ntpd-rs.service" ];
    before = [ "gpsd.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'ln -sf /run/ntpd-rs/chrony.ttyAMA0.sock /run/chrony.ttyAMA0.sock'";
      ExecStop = "${pkgs.coreutils}/bin/rm -f /run/chrony.ttyAMA0.sock";
    };
  };

  systemd.services.gpsd = {
    after = [ "gpsd-socket-shim.service" ];
    wants = [ "gpsd-socket-shim.service" ];
  };
}
