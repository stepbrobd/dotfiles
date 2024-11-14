{
  plugins.nvim-tree = {
    enable = true;

    autoReloadOnWrite = true;
    openOnSetupFile = true;
    syncRootWithCwd = true;

    disableNetrw = true;
    hijackNetrw = true;

    diagnostics.enable = true;
    modified.enable = true;
  };

  plugins.lualine.settings.extensions = [ "nvim-tree" ];

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
