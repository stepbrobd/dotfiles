{
  # https://neovim.io/doc/user/lsp.html#vim.lsp.foldexpr%28%29
  extraFiles."fold.lua".text = ''
    -- Default to treesitter folding
    vim.o.foldmethod = 'expr'
    vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

    -- Prefer LSP folding if client supports it
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client:supports_method('textDocument/foldingRange') then
          local win = vim.api.nvim_get_current_win()
          vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
        end
      end,
    })
  '';
}
