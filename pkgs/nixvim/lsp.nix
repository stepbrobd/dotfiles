{
  plugins.lsp.enable = true;
  plugins.lsp.inlayHints = true;
  plugins.lspkind.enable = true;

  plugins.lsp-format = {
    enable = true;
    lspServersToEnable = "all";
  };
  # plugins.none-ls = {
  #   enable = true;
  #   enableLspFormat = true;
  # };

  # C/C++
  plugins.lsp.servers.clangd.enable = true;

  # Coq
  plugins.lsp.servers.coq_lsp = {
    enable = true;
    package = null; # pkgs.coqPackages.coq-lsp;
  };

  # Go
  plugins.lsp.servers.gopls.enable = true;

  # HTML/JS/TS/CSS
  plugins.lsp.servers.cssls.enable = true;
  plugins.lsp.servers.denols = {
    enable = true;
    extraOptions.root_dir = "require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc')";
  };
  plugins.lsp.servers.html.enable = true;
  plugins.lsp.servers.tailwindcss.enable = true;
  plugins.lsp.servers.ts_ls = {
    enable = true;
    extraOptions.root_dir = "require('lspconfig').util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json')";
  };

  # Markdown
  plugins.lsp.servers.markdown_oxide.enable = true;

  # Nix
  plugins.lsp.servers.nil_ls.enable = true;
  plugins.lsp.servers.nixd = {
    enable = true;
    extraOptions.offset_encoding = "utf-8"; # nixvim#2390
  };
  plugins.nix.enable = true;
  plugins.nix-develop.enable = true;

  # OCaml
  plugins.lsp.servers.ocamllsp.enable = true;

  # Python
  plugins.lsp.servers.pyright.enable = true;
  plugins.lsp.servers.ruff.enable = true;

  # Shell
  plugins.lsp.servers.bashls.enable = true;
  plugins.lsp.servers.nushell.enable = true;

  # SMT2
  plugins.lsp.servers.dolmenls.enable = true;

  # Spelling
  plugins.lsp.servers.typos_lsp = {
    enable = true;
    extraOptions.init_options.diagnosticSeverity = "Hint";
  };

  # TeX
  plugins.lsp.servers.ltex.enable = true;

  # Typst
  plugins.lsp.servers.tinymist.enable = true;

  # YAML
  plugins.lsp.servers.yamlls.enable = true;
}
