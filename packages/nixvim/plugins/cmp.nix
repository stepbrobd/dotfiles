{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        completion = {
          autocomplete = [ "TextChanged" ];
          completeopt = "menu,menuone,noselect,preview";
          keywordLength = 1;
        };
        experimental = { ghost_text.hlgroup = "Comment"; };
        mapping = {
          "<cr>" = "cmp.mapping.confirm({ select = true })";
          "<tab>" = "cmp.mapping.select_next_item()";
          "<s-tab>" = "cmp.mapping.select_prev_item()";
        };
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      };
    };

    cmp-buffer.enable = true;
    cmp-cmdline.enable = true;
    cmp-dictionary.enable = true;
    cmp_luasnip.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    cmp-treesitter.enable = true;

    copilot-cmp = {
      enable = true;
      event = [ "InsertEnter" "LspAttach" ];
      fixPairs = true;
    };
    copilot-lua = {
      enable = true;
      filetypes."*" = true;
      panel.enabled = false;
      suggestion.enabled = false;
    };
  };
}
