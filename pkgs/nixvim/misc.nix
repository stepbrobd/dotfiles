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
    diffview.enable = true;
    direnv.enable = true;
    gitblame.enable = true;
    gitsigns.enable = true;
    noice.enable = true;
    nvim-autopairs.enable = true;
    octo.enable = true;
    sleuth.enable = true;
    spider.enable = true;
    todo-comments.enable = true;
    vim-surround.enable = true;
  };

  # use gh and git from PATH
  dependencies.gh.enable = false;
  dependencies.git.enable = false;

  plugins.spider.keymaps = {
    silent = true;
    motions = {
      w = "w";
      e = "e";
      b = "b";
      ge = "ge";
    };
  };

  plugins.snacks.settings.notifier.enabled = true;
  plugins.snacks.settings.image.enabled = false;
  extraConfigLuaPost = ''
    vim.ui.select = Snacks.picker.select
  '';
}
