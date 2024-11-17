{
  plugins.nvim-tree = {
    enable = true;

    autoReloadOnWrite = true;
    openOnSetupFile = true;
    syncRootWithCwd = true;

    diagnostics.enable = true;
    modified.enable = true;
  };

  # use nvim-tree as file explorer
  extraConfigLuaPre = ''
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  '';

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
