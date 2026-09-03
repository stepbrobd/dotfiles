{ lib, ... }:

{ config, pkgs, ... }:

{
  home.packages = [ pkgs.omp ];
  home.sessionVariables.PI_CONFIG_DIR = lib.removePrefix "${config.home.homeDirectory}/" "${config.xdg.configHome}/omp";
  xdg.configFile = {
    "omp/agent/AGENTS.md".source = ./context.md;
    "omp/agent/config.yaml" = {
      force = true;
      source = (pkgs.formats.yaml { }).generate "omp.yaml" {
        dev.autoqa = false;

        modelRoles.default = "openai-codex/gpt-5.6-sol";
        defaultThinkingLevel = "max";
        enabledModels = [
          "openai-codex/gpt-6-astra:max"
          "openai-codex/gpt-5.6-sol:max"
          "openai-codex/gpt-5.6-terra:max"
          "openai-codex/gpt-5.6-luna:max"
          "openrouter/z-ai/glm-5.2:free:xhigh"
          "openrouter/minimax/minimax-m3:free"
          "openrouter/thinkingmachines/inkling:free:max"
          "openrouter/nvidia/nemotron-3-ultra-550b-a55b:free:high"
          "openrouter/poolside/laguna-s-2.1:free"
        ];

        marketplace.autoUpdate = "notify";
        startup = {
          quiet = false;
          changelogMode = "summary";
          checkUpdate = false;
          setupWizard = false;
        };

        theme = {
          dark = "dark-nord";
          light = "dark-nord";
        };
        symbolPreset = "ascii";
        composer.shape = "pi";

        statusLine = {
          preset = "ascii";
          separator = "ascii";
          contextLine = "annotated";
          sessionAccent = true;
          transparent = true;
          compactThinkingLevel = true;
          showHookStatus = true;
        };

        tui = {
          tight = false;
          resizeScrollback = "rebuild";
          imeSafeCursor = false;
        };

        display = {
          shimmer = "classic";
          hideToolActivity = false;
          showTokenUsage = true;
          cacheMissMarker = true;
        };

        autocompleteMaxVisible = 10;
        showHardwareCursor = true;

        doubleEscapeAction = "tree";
        treeFilterMode = "user-only";
        steeringMode = "one-at-a-time";
        tools.approvalMode = "yolo";

        compaction = {
          enabled = true;
          reserveTokens = 32768;
          keepRecentTokens = 65536;
        };

        providers = {
          cacheRetention = "long";
          streamIdleTimeoutSeconds = 250;
        };
        retry = {
          enabled = true;
          maxRetries = 5;
          baseDelayMs = 5000;
        };

        github.enabled = true;
        lsp.diagnosticsOnEdit = true;

        terminal = {
          showImages = true;
          showProgress = true;
        };

        images = {
          autoResize = true;
          blockImages = false;
        };
      };
    };
  };
}
