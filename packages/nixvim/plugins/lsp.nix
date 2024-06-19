{ pkgs, ... }:

{
  plugins = {
    lsp.enable = true;
    lsp-format = {
      enable = true;
      lspServersToEnable = "all";
    };
    lspkind.enable = true;
    typst-vim = {
      enable = true;
      settings.pdf_viewer = "zathura";
    };
  };

  extraPlugins = with pkgs.vimPlugins; [
    Coqtail
  ];
}
