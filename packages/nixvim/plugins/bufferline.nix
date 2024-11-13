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
}
