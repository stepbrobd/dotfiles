{ config, ... }:

{
  programs.claude-code = {
    enable = true;
    configDir = "${config.xdg.configHome}/claude";
  };

  home.sessionVariables.PI_CACHE_RETENTION = "long";
  home.sessionVariables.PI_SKIP_VERSION_CHECK = "1";
  programs.pi-coding-agent = {
    enable = true;
    configDir = "${config.xdg.configHome}/pi/agent";

    context = ./context.md;

    settings = {
      defaultProjectTrust = "always";

      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-sol";
      defaultThinkingLevel = "max";

      enabledModels = [
        "openai-codex/gpt-5.6-sol:max"
        "openai-codex/gpt-5.6-terra:max"
        "openai-codex/gpt-5.6-luna:max"
        "openrouter/z-ai/glm-5.2:free:high"
        "openrouter/nvidia/nemotron-3-super-120b-a12b:free:medium"
        "openrouter/thinkingmachines/inkling:free"
        "openrouter/cohere/north-mini-code:free:high"
        "openrouter/nvidia/nemotron-3.5-lightning:free:high"
      ];

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
