{ pkgs, ... }:

{
  plugins.lsp.enable = true;
  plugins.lspkind.enable = true;
  plugins.lsp-format = {
    enable = true;
    lspServersToEnable = "all";
  };

  plugins.none-ls = {
    enable = true;
    enableLspFormat = true;
  };

  # C/C++
  plugins.lsp.servers.cmake.enable = true;
  plugins.lsp.servers.clangd.enable = true;

  # Coq
  plugins.lsp.servers.coq_lsp.enable = true;
  plugins.lsp.servers.coq_lsp.package = pkgs.coqPackages.coq-lsp;
  extraPlugins = with pkgs.vimPlugins; [ Coqtail ];

  # Docker
  plugins.lsp.servers.dockerls.enable = true;
  plugins.lsp.servers.docker_compose_language_service.enable = true;

  # Go
  plugins.lsp.servers.gopls.enable = true;

  # HTML/JS/TS/CSS
  plugins.lsp.servers.cssls.enable = true; # CSS
  plugins.lsp.servers.html.enable = true; # HTML
  plugins.lsp.servers.tailwindcss.enable = true; # TailwindCSS
  plugins.lsp.servers.ts_ls.enable = true; # TS/JS

  # JSON
  plugins.lsp.servers.jsonls.enable = true;

  # Lean
  # plugins.lean.enable = true;

  # Markdown
  plugins.lsp.servers.marksman.enable = true;

  # Nix
  plugins.lsp.servers.nil_ls.enable = true;
  plugins.lsp.servers.nixd = {
    enable = true;
    extraOptions.offset_encoding = "utf-8"; # nixvim #2390
    settings.expr = "import <nixpkgs> { }";
  };
  plugins.nix.enable = true;
  plugins.nix-develop.enable = true;

  # OCaml
  plugins.lsp.servers.ocamllsp.enable = true;
  plugins.lsp.servers.ocamllsp.package = pkgs.ocamlPackages.ocaml-lsp;

  # Python
  plugins.lsp.servers.jedi_language_server.enable = true;
  plugins.lsp.servers.pyright.enable = true;
  plugins.lsp.servers.pylsp.enable = true;
  plugins.lsp.servers.ruff.enable = true;

  # Shell
  plugins.lsp.servers.bashls.enable = true;
  plugins.lsp.servers.nushell.enable = true;

  # Spelling
  plugins.lsp.servers.typos_lsp.enable = true;

  # TeX
  plugins.lsp.servers.ltex.enable = true;

  # Typst
  plugins.lsp.servers.tinymist.enable = true;
  plugins.typst-vim = {
    enable = true;
    settings.pdf_viewer = "zathura";
  };

  # YAML
  plugins.lsp.servers.yamlls.enable = true;
}
