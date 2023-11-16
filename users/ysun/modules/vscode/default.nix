# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.vscode = {
    enable = true;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      b4dm4n.vscode-nixpkgs-fmt
      bbenoist.nix
      bradlc.vscode-tailwindcss
      charliermarsh.ruff
      davidanson.vscode-markdownlint
      dbaeumer.vscode-eslint
      denoland.vscode-deno
      dotjoshjohnson.xml
      eamodio.gitlens
      esbenp.prettier-vscode
      foxundermoon.shell-format
      github.codespaces
      github.copilot
      github.copilot-chat
      github.vscode-github-actions
      github.vscode-pull-request-github
      golang.go
      grapecity.gc-excelviewer
      hashicorp.terraform
      haskell.haskell
      james-yu.latex-workshop
      justusadam.language-haskell
      llvm-vs-code-extensions.vscode-clangd
      marp-team.marp-vscode
      mechatroner.rainbow-csv
      ms-azuretools.vscode-docker
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      ms-vscode-remote.remote-containers
      ms-vscode-remote.remote-ssh
      ms-vscode.cmake-tools
      nvarner.typst-lsp
      redhat.vscode-yaml
      rust-lang.rust-analyzer
      shd101wyy.markdown-preview-enhanced
      streetsidesoftware.code-spell-checker
      tamasfe.even-better-toml
      tomoki1207.pdf
      unifiedjs.vscode-mdx
      vscode-icons-team.vscode-icons
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];

    userSettings = {
      "telemetry.telemetryLevel" = "off";
      "update.mode" = "none";
      "extensions.autoCheckUpdates" = false;
      "window.titleBarStyle" = "custom";
      "workbench.startupEditor" = "none";
      "workbench.colorTheme" = "Nord";
      "workbench.iconTheme" = "vscode-icons";
      "vsicons.dontShowNewVersionMessage" = true;
      "editor.fontSize" = 12;
      "editor.fontLigatures" = true;
      "editor.fontFamily" = "JetBrainsMono Nerd Font";
      "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
      "terminal.integrated.confirmOnExit" = "hasChildProcesses";
    };
  };
}
