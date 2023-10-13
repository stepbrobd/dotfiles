# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  services.mpd = {
    enable = true;
    network.listenAddress = "any";
    extraConfig = ''
      auto_update "yes"
      audio_output {
          type "pipewire"
          name "PipeWire"
      }
    '';
  };
}
