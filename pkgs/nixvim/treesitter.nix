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

  plugins.treesitter.grammarPackages = [
    pkgs.tree-sitter-grammars.tree-sitter-rocq
  ] ++ pkgs.vimPlugins.nvim-treesitter.allGrammars;

  plugins.treesitter.languageRegister.rocq = [ "coq" ];
  plugins.treesitter.languageRegister.typescript = "nixts";
}
