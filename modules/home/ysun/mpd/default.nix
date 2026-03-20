{
  services.mpd = {
    enable = true;

    enableSessionVariables = false;

    network.listenAddress = "::1";
    extraConfig = ''
      auto_update "yes"
      audio_output {
          type "pipewire"
          name "PipeWire"
      }
    '';
  };
}
