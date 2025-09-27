{
  plugins.toggleterm = {
    enable = true;
    settings.shade_terminals = false;
  };

  plugins.lualine.settings.extensions = [ "toggleterm" ];

  keymaps = [
    {
      mode = "n";
      key = "<leader>tf";
      action = "<cmd>:ToggleTerm direction=float<cr>";
      options = {
        silent = true;
        desc = "Start a new floating terminal";
      };
    }
    {
      mode = "n";
      key = "<leader>th";
      action = "<cmd>:ToggleTerm direction=horizontal size=20<cr>";
      options = {
        silent = true;
        desc = "Start a new horizontal terminal";
      };
    }
    {
      mode = "n";
      key = "<leader>tv";
      action = "<cmd>:ToggleTerm direction=vertical size=20<cr>";
      options = {
        silent = true;
        desc = "Start a new vertical terminal";
      };
    }
    {
      mode = "n";
      key = "<leader>tx";
      action = "<cmd>:ToggleTermToggleAll!<cr>";
      options = {
        silent = true;
        desc = "Quit all terminal sessions";
      };
    }
  ];
}
