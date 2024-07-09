# https://github.com/nix-community/nixvim

{ stdenv
, lib
, inputs
}:

let
  nixvim = inputs.nixvim.legacyPackages."${stdenv.system}";
in
lib.makeOverridable nixvim.makeNixvimWithModule {
  module = {
    imports = [
      ./plugins/cmp.nix
      ./plugins/colorscheme.nix
      ./plugins/dashboard.nix
      ./plugins/explorer.nix
      ./plugins/lsp.nix
      ./plugins/tree-sitter.nix
    ];

    config = {
      opts = {
        encoding = "utf-8";
        title = true;
        wrap = false;
        number = true;
        relativenumber = true;
        clipboard = "unnamedplus";
        incsearch = true;
        ignorecase = true;
        smartcase = true;
        expandtab = true;
        undofile = true;
        autoindent = true;
        smartindent = true;
        smarttab = true;
      };

      plugins = {
        bufferline = {
          enable = true;
          alwaysShowBufferline = false;
          diagnostics = "nvim_lsp";
        };
        diffview.enable = true;
        gitblame.enable = true;
        gitsigns.enable = true;
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
        oil.enable = true;
        presence-nvim.enable = true;
        rainbow-delimiters.enable = true;
        spider.enable = true;
        surround.enable = true;
        telescope.enable = true;
        toggleterm.enable = true;
      };
    };
  };
}
