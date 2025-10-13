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
    autoclose.enable = true;
    diffview.enable = true;
    gitblame.enable = true;
    gitsigns.enable = true;
    luasnip.enable = true;
    noice.enable = true;
    notify.enable = true;
    presence.enable = true;
    rainbow-delimiters.enable = true;
    sniprun.enable = true;
    spider.enable = true;
    todo-comments.enable = true;
    vim-surround.enable = true;
  };
}
