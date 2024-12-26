{ lib, ... }:

{
  security.sudo.execWheelOnly = lib.mkForce false;
  security.sudo.extraRules = [{
    users = [ "ysun" ];
    commands = [{ command = "ALL"; options = [ "NOPASSWD" "SETENV" ]; }];
  }];
}
