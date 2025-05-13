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

  plugins.yazi.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader><tab>";
      action = "<cmd>:NvimTreeToggle<cr>";
      options = {
        silent = true;
        desc = "Toggle file manager";
      };
    }
    {
      mode = "n";
      key = "<leader>y";
      action = "<CMD>Yazi<CR>";
      options = {
        silent = true;
        desc = "Toggle Yazi file manager (current file)";
      };
    }
    {
      mode = "n";
      key = "<leader>Y";
      action = "<CMD>Yazi toggle<CR>";
      options = {
        silent = true;
        desc = "Toggle Yazi file manager";
      };
    }
  ];
}
