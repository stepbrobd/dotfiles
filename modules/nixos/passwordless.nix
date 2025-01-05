{ lib, ... }:

{
  security.sudo = {
    execWheelOnly = lib.mkForce true;
    extraRules = lib.mkForce [
      {
        users = [ "root" ];
        commands = [{ command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; }];
      }
      {
        groups = [ "wheel" ];
        commands = [{ command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; }];
      }
    ];
  };
}
