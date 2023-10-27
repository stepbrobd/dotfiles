# nixpkgs options

{ config
, lib
, pkgs
, ...
}:

{
  boot = lib.mkForce {
    plymouth.enable = true;

    consoleLogLevel = 0;

    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    kernelParams = [
      "quiet"
      "loglevel=3"
      "udev.log_level=3"
      "boot.shell_on_fail"
      "rd.udev.log_level=3"
      "systemd.show_status=auto"
      "vt.global_cursor_default=0"
    ];
  };
}
