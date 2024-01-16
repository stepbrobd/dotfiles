# nixvim home-manager options (from [nixvim](https://nix-community.github.io/nixvim))

{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    options = {
      number = true;
      relativenumber = true;
    };

    colorschemes.nord.enable = true;

    plugins = {
      alpha = {
        enable = true;
        layout = [
          {
            type = "padding";
            val = 10;
          }
          {
            opts = {
              hl = "Keyword";
              position = "center";
            };
            type = "text";
            val = "not";
          }
          {
            type = "padding";
            val = 1;
          }
          {
            opts = {
              hl = "Type";
              position = "center";
            };
            type = "text";
            val = [
              "███████╗███╗   ███╗ █████╗  ██████╗███████╗"
              "██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝"
              "█████╗  ██╔████╔██║███████║██║     ███████╗"
              "██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║"
              "███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║"
              "╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝"
            ];
          }
          {
            type = "padding";
            val = 5;
          }
          {
            type = "group";
            val = [
              {
                command = ":ene <BAR> startinsert <CR>";
                desc = "  New File";
                shortcut = "n";
              }
              {
                command = ":Telescope find_files <CR>";
                desc = "  Find File";
                shortcut = "f";
              }
              {
                command = ":Telescope live_grep <CR>";
                desc = "  Live Grep";
                shortcut = "g";
              }
              {
                command = ":qa<CR>";
                desc = "  Quit";
                shortcut = "q";
              }
            ];
          }
          {
            type = "padding";
            val = 5;
          }
          {
            opts = {
              hl = "Keyword";
              position = "center";
            };
            type = "text";
            val = "its neovim";
          }
        ];
      };
      bufferline = {
        enable = true;
        alwaysShowBufferline = false;
        diagnostics = "nvim_lsp";
      };
      chadtree.enable = true;
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
      diffview.enable = true;
      gitblame.enable = true;
      gitsigns.enable = true;
      lsp.enable = true;
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      lspkind.enable = true;
      lualine = {
        enable = true;
        iconsEnabled = true;
        theme = "nord";
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" ];
          lualine_c = [ "diff" "diagnostics" ];
          lualine_x = [ "filetype" "encoding" ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
      };
      luasnip.enable = true;
      nix.enable = true;
      nix-develop.enable = true;
      noice.enable = true;
      notify.enable = true;
      nvim-cmp = {
        enable = true;
        sources = [
          { name = "buffer"; }
          { name = "cmdline"; }
          { name = "dictionary"; }
          { name = "path"; }
          { name = "treesitter"; }
          { name = "luasnip"; }
          { name = "copilot"; }
        ];
        mapping = {
          "<cr>" = "cmp.mapping.confirm({ select = true })";
          "<tab>" = "cmp.mapping.select_next_item()";
          "<s-tab>" = "cmp.mapping.select_prev_item()";
        };
        completion.autocomplete = [ "TextChanged" ];
        completion.completeopt = "menu,menuone,noselect,preview";
        completion.keywordLength = 1;
        experimental = { ghost_text.hlgroup = "Comment"; };
        snippet.expand = "luasnip";
      };
      presence-nvim.enable = true;
      rainbow-delimiters.enable = true;
      spider.enable = true;
      surround.enable = true;
      telescope.enable = true;
      toggleterm.enable = true;
      treesitter.enable = true;
      treesitter-context.enable = true;
      treesitter-refactor.enable = true;
      treesitter-textobjects.enable = true;
      typst-vim = {
        enable = true;
        pdfViewer = "zathura";
      };
    };
  };
}
