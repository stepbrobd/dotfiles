{
  plugins.web-devicons.enable = true;
  plugins.bufferline = {
    enable = true;
    settings.options = {
      always_show_bufferline = false;
      diagnostics = "nvim_lsp";
      offsets = [
        {
          filetype = "NvimTree";
          text = "File Explorer";
          highlight = "Directory";
          text_align = "left";
          separator = true;
        }
      ];
    };
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>bn";
      action = "<cmd>BufferLineCycleNext<cr>";
      options = { silent = true; desc = "Next buffer"; };
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLineCyclePrev<cr>";
      options = { silent = true; desc = "Previous buffer"; };
    }
  ];
}
