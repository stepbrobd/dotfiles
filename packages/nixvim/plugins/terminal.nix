{
  plugins.toggleterm = {
    enable = true;
    settings.shade_terminals = false;
  };

  plugins.lualine.settings.extensions = [ "toggleterm" ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>t";
      action = "<cmd>:ToggleTerm<cr>";
      options = {
        silent = true;
        desc = "Start a new terminal";
      };
    }
    {
      mode = "n";
      key = "<leader>T";
      action = "<cmd>:ToggleTermToggleAll!<cr>";
      options = {
        silent = true;
        desc = "Quit all terminal sessions";
      };
    }
  ];
}
