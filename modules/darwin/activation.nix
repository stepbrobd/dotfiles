# nix-darwin options

{ config
, lib
, pkgs
, ...
}:

{
  system.activationScripts.extraActivation.text = ''
    if [[ "$(systemsetup -getremotelogin | sed 's/Remote Login: //')" == "Off" ]]; then
      launchctl load -w /System/Library/LaunchDaemons/ssh.plist
    fi
  '';
}
