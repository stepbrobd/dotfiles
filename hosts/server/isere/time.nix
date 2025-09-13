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
  # hardware.raspberry-pi.config.all = {
  #   options.force_turbo = {
  #     enable = true;
  #     value = 1;
  #   };

  #   base-dt-params = {
  #     uart0 = {
  #       enable = true;
  #       value = "on";
  #     };
  #     i2c_arm = {
  #       enable = true;
  #       value = "on";
  #     };
  #     rtc = {
  #       enable = true;
  #       value = "off";
  #     };
  #   };

  #   dt-overlays = {
  #     uart0-pi5 = {
  #       enable = true;
  #       params = { };
  #     };
  #     i2c-rtc = {
  #       enable = true;
  #       params = {
  #         rv3028.enable = true;
  #         addr = {
  #           enable = true;
  #           value = "0x52";
  #         };
  #       };
  #     };
  #     pps-gpio = {
  #       enable = true;
  #       params.gpiopin = {
  #         enable = true;
  #         value = 18;
  #       };
  #     };
  #   };
  # };
  hardware.raspberry-pi.extra-config = ''
    [pi5]
    # To enable hardware serial UART interface over GPIO 14 and 15 (specific for 5B model)
    dtparam=uart0_console=on

    # Enable uart 0 on GPIOs 14-15. Pi 5 only.
    dtoverlay=uart0-pi5

    # Disables the undocumented RPi 5B RTC DA9091
    dtparam=rtc=off

    # Default presets of RPi 5B PWN fan control setpoints
    dtparam=fan_temp0=50000
    dtparam=fan_temp0_hyst=5000
    dtparam=fan_temp0_speed=75

    dtparam=fan_temp1=60000
    dtparam=fan_temp1_hyst=5000
    dtparam=fan_temp1_speed=125

    dtparam=fan_temp2=67500
    dtparam=fan_temp2_hyst=5000
    dtparam=fan_temp2_speed=175

    dtparam=fan_temp3=75000
    dtparam=fan_temp3_hyst=5000
    dtparam=fan_temp3_speed=250

    [all]
    # Uses the /dev/ttyAMA0 UART GNSS instead of Bluetooth
    dtoverlay=miniuart-bt

    # Disables Bluetooth for better accuracy and lower interferance - optional
    dtoverlay=disable-bt

    # Disables Wifi for better accuracy and lower interferance - optional
    dtoverlay=disable-wifi

    # For GPS Expansion Board from Uputronics
    dtparam=i2c_arm=on
    dtoverlay=i2c-rtc,rv3028,wakeup-source,backup-switchover-mode=3
    dtoverlay=pps-gpio,gpiopin=18
    init_uart_baud=115200

    # Disables kernel power saving
    nohz=off

    # Force CPU high speed clock
    force_turbo=1
  '';

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
}
