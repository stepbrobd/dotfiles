{
  services.mpd = {
    enable = true;

    enableSessionVariables = false;

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
