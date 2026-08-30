{ pkgs, ... }:

{
  plugins = {
    treesitter.enable = true;
    treesitter.folding.enable = true;
    treesitter.highlight.enable = true;
    treesitter-context.enable = true;
    # treesitter-refactor.enable = true;
    # treesitter-textobjects.enable = true;
  };

  extraPlugins = with pkgs.vimPlugins; [
    # nvim-treesitter-sexp
    pkgs.tree-sitter-grammars.tree-sitter-rocq
  ];

  plugins.treesitter.grammarPackages =
    pkgs.vimPlugins.nvim-treesitter.allGrammars
    ++
    [ pkgs.tree-sitter-grammars.tree-sitter-rocq ];

  plugins.treesitter.languageRegister.rocq = [ "coq" "v" ];
  plugins.treesitter.languageRegister.typescript = "nixts";
}
