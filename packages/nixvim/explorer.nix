{
  plugins.nvim-tree = {
    enable = true;

    autoReloadOnWrite = true;
    openOnSetupFile = true;
    syncRootWithCwd = true;

    diagnostics.enable = true;
    modified.enable = true;
  };

  plugins.oil.enable = true;

  plugins.lualine.settings.extensions = [ "nvim-tree" "oil" ];

  keymaps = [{
    mode = "n";
    key = "<leader><tab>";
    action = "<cmd>:NvimTreeToggle<cr>";
    options = {
      silent = true;
      desc = "Toggle file manager";
    };
  }];
}
