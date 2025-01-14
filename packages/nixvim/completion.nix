# https://github.com/MikaelFangel/nixvim-config/blob/92924c1938e48fd3b77166e616ae6e6bd4a5587b/config/cmp.nix

{
  plugins = {
    copilot-lua = {
      enable = true;
      settings = {
        suggestion.enabled = false;
        panel.enabled = false;
      };
      settings.filetypes = {
        gitcommit = true;
        gitrebase = true;
        markdown = true;
      };
    };

    coq-nvim.enable = true;
    coq-thirdparty.enable = true;

    cmp = {
      enable = true;

      settings = {
        completion.completeopt = "menu,menuone,noinsert";
        experimental.ghost_text = true;

        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';

        autoEnableSources = true;
        sources = [
          {
            name = "buffer";
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
          { name = "cmdline"; }
          { name = "copilot"; }
          { name = "dap"; }
          { name = "dictionary"; }
          { name = "emoji"; }
          { name = "git"; }
          { name = "greek"; }
          { name = "latex_symbols"; }
          { name = "look"; }
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_document_symbol"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "nvim_lua"; }
          { name = "path"; }
          { name = "rg"; }
          { name = "spell"; }
          { name = "treesitter"; }
          { name = "ultisnips"; }
          { name = "vsnip"; }
          { name = "yanky"; }
          { name = "zsh"; }
        ];

        # window = {
        #   completion = {
        #     winhighlight =
        #       "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
        #     scrollbar = false;
        #     sidePadding = 0;
        #     border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
        #   };
        #   settings.documentation = {
        #     border = [ "╭" "─" "╮" "│" "╯" "─" "╰" "│" ];
        #     winhighlight =
        #       "FloatBorder:CmpBorder,Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel";
        #   };
        # };

        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-j>" = "cmp.mapping.select_next_item()";
          "<C-k>" = "cmp.mapping.select_prev_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<S-Tab>" = "cmp.mapping.close()";
          "<Tab>" =
            # lua 
            ''
              function(fallback)
                local line = vim.api.nvim_get_current_line()
                if line:match("^%s*$") then
                  fallback()
                elseif cmp.visible() then
                  cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
                else
                  fallback()
                end
              end
            '';
          "<Down>" =
            # lua
            ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require("luasnip").expand_or_jumpable() then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                else
                  fallback()
                end
              end
            '';
          "<Up>" =
            # lua
            ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                else
                  fallback()
                end
              end
            '';
        };
      };
    };
  };
}
