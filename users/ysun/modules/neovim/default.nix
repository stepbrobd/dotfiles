# home-manager options

{ config
, lib
, pkgs
, ...
}:

{
  programs.neovim = {
    enable = true;

    plugins = with pkgs.vimPlugins; [
      nord-nvim
      lualine-nvim
    ];

    extraConfig = ''
      colorscheme nord

      set number
      set relativenumber
    '';

    extraLuaConfig = ''
            require("lualine").setup {
              options = {
      	  theme = "auto",
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
