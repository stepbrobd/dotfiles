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

    colorschemes.nord.enable = true;

    options = {
      number = true;
      relativenumber = true;
    };

    plugins = {
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
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-path.enable = true;
      cmp-spell.enable = true;
      cmp-treesitter.enable = true;
      copilot-vim = {
        enable = true;
        filetypes."*" = true;
      };
      dashboard = {
        enable = true;
        hideStatusline = true;
        hideTabline = true;
      };
      diffview.enable = true;
      gitblame.enable = true;
      gitsigns.enable = true;
      lsp.enable = true;
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      lualine = {
        enable = true;
        globalstatus = true;
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
      typst-vim.enable = true;
    };
  };
}
