{ pkgs, ... }:

{
  plugins = {
    treesitter.enable = true;
    treesitter.folding.enable = true;
    # treesitter-context.enable = true;
    # treesitter-refactor.enable = true;
    # treesitter-textobjects.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    # nvim-treesitter-sexp
    pkgs.treesitter-coq-grammar
  ];

  plugins.treesitter.grammarPackages =
    pkgs.vimPlugins.nvim-treesitter.allGrammars
    ++
    [ pkgs.treesitter-coq-grammar ];

  plugins.treesitter.languageRegister.coq = "v";
}
