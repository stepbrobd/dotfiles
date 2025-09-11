{ pkgs, ... }:

{
  systemd.services."serial-getty@ttyAMA0".enable = false;

  # services.udev.extraRules = ''
  #   SUBSYSTEM=="tty", KERNEL=="ttyAMA0", OWNER="root", GROUP="gpsd", MODE="0666"
  #   SUBSYSTEM=="pps", KERNEL=="pps0", OWNER="root", GROUP="gpsd", MODE="0666"
  # '';

  boot.kernelModules = [ "pps-gpio" ];
  hardware.raspberry-pi.config.all = {
    options = {
      init_uart_baud = {
        enable = true;
        value = 115200;
      };
      nohz = {
        enable = true;
        value = "off";
      };
      force_turbo = {
        enable = true;
        value = 1;
      };
    };

    base-dt-params = {
      i2c_arm = {
        enable = true;
        value = "on";
      };
      # uart0_console = {
      #   enable = true;
      #   value = "on";
      # };
    };

    dt-overlays = {
      uart0-pi5 = {
        enable = true;
        params = { };
      };
      "i2c-rtc,rv3028" = {
        enable = true;
        params = { };
      };
      "pps-gpio,gpiopin=18" = {
        enable = true;
        params = { };
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
