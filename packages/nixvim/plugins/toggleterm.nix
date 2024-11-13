{
  plugins.toggleterm = {
    enable = true;
    settings.shade_terminals = false;
  };

  plugins.lualine.settings.extensions = [ "toggleterm" ];
}
