{
  plugins.telescope.enable = true;
  plugins.web-devicons.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>:Telescope find_files<cr>";
      options = {
        silent = true;
        desc = "Telescope find files";
      };
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>:Telescope live_grep<cr>";
      options = {
        silent = true;
        desc = "Telescope live grep";
      };
    }
    {
      mode = "n";
      key = "<leader>fb";
      action = "<cmd>:Telescope buffers<cr>";
      options = {
        silent = true;
        desc = "Telescope list buffers";
      };
    }
  ];
}
