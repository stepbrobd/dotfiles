{ pkgs, ... }:

{
  programs.opencode = {
    enable = true;
    package = pkgs.llm-agents.opencode;

    settings = {
      autoupdate = false;
      theme = "nord";
    };
  };

  programs.claude-code = {
    enable = true;
    package = pkgs.llm-agents.claude-code;
  };

  programs.codex = {
    enable = true;
    package = pkgs.llm-agents.codex;
  };
}
