{ pkgs, ... }:

{
  viAlias = false;
  vimAlias = false;
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
    diffview.enable = true;
    gitblame.enable = true;
    gitsigns.enable = true;
    luasnip.enable = true;
    nix.enable = true;
    nix-develop.enable = true;
    noice.enable = true;
    notify.enable = true;
    presence-nvim.enable = true;
    rainbow-delimiters.enable = true;
    spider.enable = true;
    telescope.enable = true;
    toggleterm.enable = true;
    vim-surround.enable = true;
    web-devicons.enable = true;
  };
}
