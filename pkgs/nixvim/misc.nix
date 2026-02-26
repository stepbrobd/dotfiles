{
  viAlias = false;
  vimAlias = false;
  wrapRc = true;

  withNodeJs = false;
  withPerl = false;
  withPython3 = false;
  withRuby = false;

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
