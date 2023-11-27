# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.neovim = {
    enable = lib.warn
      "the use of `programs.neovim` is deprecated in favor of `programs.nixvim`"
      true;

    plugins = with pkgs.vimPlugins; [
      cmp-cmdline
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      editorconfig-vim
      flash-nvim
      indent-blankline-nvim
      lualine-nvim
      luasnip
      nord-nvim
      nvim-cmp
      nvim-lspconfig
      nvim-treesitter-context
      nvim-treesitter.withAllGrammars
      nvim-web-devicons
      presence-nvim
      telescope-nvim
      vim-css-color
    ];

    extraConfig = ''
      colorscheme nord

      set number
      set relativenumber

      set cmdheight=0
      set laststatus=2
    '';

    extraLuaConfig = ''
      require("lualine").setup {
        options = {
      	  theme = "nord",
          icons_enabled = true,
      	  component_separators = {
      	    left = "",
      	    right = "",
      	  },
      	  section_separators = {
      	    left = "",
      	    right = "",
      	  },
      	},
      sections = {
      	lualine_a = { "mode" },
      	lualine_b = { "branch", "diff", "diagnostics" },
      	lualine_c = {},
      	lualine_x = {},
      	lualine_y = { "filetype", "encoding" },
      	lualine_z = { "location" },
      	},
      }
    '';
  };
}
