{
  plugins.trouble = {
    enable = true;
    settings = {
      auto_close = true;
      auto_jump = true;
      auto_refresh = true;
      follow = false;
    };
  };

  keymaps = [
    {
      key = "<leader>dd";
      action = "<cmd>Trouble diagnostics toggle<cr>";
      options = {
        silent = true;
        desc = "Toggle diagnostics";
      };
    }
    {
      key = "<leader>dl";
      action = "<cmd>Trouble lsp toggle<cr>";
      options = {
        silent = true;
        desc = "Toggle LSP diagnostics";
      };
    }
    {
      key = "<leader>df";
      action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
      options = {
        silent = true;
        desc = "Code action";
      };
    }
  ];
}
