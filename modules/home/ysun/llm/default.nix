{ config, ... }:

{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
  };

  programs.codex.enable = false;

  programs.pi-coding-agent = {
    enable = true;
    configDir = "${config.xdg.configHome}/pi/agent";
  };
}
