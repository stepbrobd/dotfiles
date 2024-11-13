{ pkgs, ... }:

{
  viAlias = true;
  vimAlias = true;
  wrapRc = true;
  withRuby = true;
  withNodeJs = true;

  luaLoader.enable = true;
  performance.byteCompileLua = {
    enable = true;
    configs = true;
    initLua = true;
    nvimRuntime = true;
    plugins = true;
  };

  plugins = {
    bufferline = {
      enable = true;
      settings.options = {
        always_show_bufferline = false;
        diagnostics = "nvim_lsp";
      };
    };
    diffview.enable = true;
    gitblame.enable = true;
    gitsigns.enable = true;
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "nord";
          icons_enabled = true;
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" ];
          lualine_c = [ "diff" "diagnostics" ];
          lualine_x = [ "filetype" "encoding" ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
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
    telescope.enable = true;
    toggleterm.enable = true;
    vim-surround.enable = true;
    web-devicons.enable = true;
  };
}
