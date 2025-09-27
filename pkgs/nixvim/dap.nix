{
  plugins.dap.enable = true;

  plugins.dap-ui = {
    enable = true;
    settings.controls.enabled = true;
  };

  plugins.dap-go.enable = true;
  plugins.dap-python.enable = true;
  plugins.dap-virtual-text.enable = true;

  plugins.lualine.settings.extensions = [ "nvim-dap-ui" ];
}
