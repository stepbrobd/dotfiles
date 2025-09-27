{ pkgs, ... }:

{
  plugins = {
    treesitter.enable = true;
    treesitter.folding = true;
    treesitter-context.enable = true;
    treesitter-refactor.enable = true;
    treesitter-textobjects.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [ nvim-treesitter-sexp ];
}
