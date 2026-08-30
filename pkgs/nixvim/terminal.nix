{
  keymaps = [
    {
      mode = "n";
      key = "<leader>tf";
      action.__raw = ''function() Snacks.terminal.toggle(nil, { win = { position = "float" } }) end'';
      options = { silent = true; desc = "Start a new floating terminal"; };
    }
    {
      mode = "n";
      key = "<leader>th";
      action.__raw = ''function() Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 20 } }) end'';
      options = { silent = true; desc = "Start a new horizontal terminal"; };
    }
    {
      mode = "n";
      key = "<leader>tv";
      action.__raw = ''function() Snacks.terminal.toggle(nil, { win = { position = "right",  width  = 60 } }) end'';
      options = { silent = true; desc = "Start a new vertical terminal"; };
    }
    {
      mode = "n";
      key = "<leader>tx";
      action.__raw = ''
        function()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end
      '';
      options = { silent = true; desc = "Quit all terminal sessions"; };
    }
  ];
}
