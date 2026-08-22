{ config, ... }:

{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
  };

  programs.codex.enable = false;

  home.sessionVariables.PI_SKIP_VERSION_CHECK = "1";
  programs.pi-coding-agent = {
    enable = true;
    configDir = "${config.xdg.configHome}/pi/agent";

    settings = {
      defaultProjectTrust = "always";

      theme = "dark";
      tuiMode = "regular";
      quietStartup = true;
      collapseChangelog = true;
      enableInstallTelemetry = false;
      warnings.anthropicExtraUsage = true;

      outputPad = 1;
      editorPaddingX = 1;
      autocompleteMaxVisible = 10;

      showHardwareCursor = true;
      showCacheMissNotices = true;

      doubleEscapeAction = "tree";
      treeFilterMode = "user-only";

      defaultTools = [
        "bash"
        "edit"
        "find"
        "grep"
        "ls"
        "read"
        "write"
      ];

      compaction = {
        enabled = true;
        reserveTokens = 32768;
        keepRecentTokens = 65536;
      };

      steeringMode = "one-at-a-time";
      transport = "auto";
      httpIdleTimeoutMs = 250000;
      retry = {
        enabled = true;
        maxRetries = 5;
        baseDelayMs = 5000;
      };

      terminal = {
        showImages = true;
        showTerminalProgress = true;
        clearOnShrink = true;
      };

      markdown.mermaid = "streaming";

      images = {
        autoResize = true;
        blockImages = false;
      };
    };
  };
}
