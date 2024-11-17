{
  plugins.dap = {
    enable = true;

    extensions = {
      dap-ui = {
        enable = true;
        controls.enabled = false;
      };

      dap-go.enable = true;
      dap-python.enable = true;
      dap-virtual-text.enable = true;
    };
  };

  plugins.lualine.settings.extensions = [ "nvim-dap-ui" ];
}
