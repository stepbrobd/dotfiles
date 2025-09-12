{ pkgs, ... }:

{
  systemd.services."serial-getty@ttyAMA0".enable = false;

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", KERNEL=="ttyAMA0", OWNER="root", GROUP="gpsd", MODE="0666"
    SUBSYSTEM=="pps", KERNEL=="pps0", OWNER="root", GROUP="gpsd", MODE="0666"
  '';

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
    };

    dt-overlays = {
      uart0-pi5 = {
        enable = true;
        params = { };
      };
      i2c-rtc = {
        enable = true;
        params.rv3028.enable = true;
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

  environment.systemPackages = with pkgs; [ gpsd pps-tools ];

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
}
