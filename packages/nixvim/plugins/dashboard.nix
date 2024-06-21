{
  plugins.alpha = {
    enable = true;
    layout = [
      {
        type = "padding";
        val = 10;
      }
      {
        type = "text";
        val = "not";
        opts.position = "center";
      }
      {
        type = "padding";
        val = 1;
      }
      {
        type = "text";
        val = [
          "███████╗███╗   ███╗ █████╗  ██████╗███████╗"
          "██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝"
          "█████╗  ██╔████╔██║███████║██║     ███████╗"
          "██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║"
          "███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║"
          "╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝"
        ];
        opts.position = "center";
      }
      {
        type = "padding";
        val = 5;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "      New File";
            opts.shortcut = "n";
            on_press.__raw = "function() vim.cmd[[ene | startinsert]] end";
          }
          {
            type = "button";
            val = "      Find File";
            opts.shortcut = "f";
            on_press.__raw = "function() vim.cmd[[Telescope find_files]] end";
          }
          {
            type = "button";
            val = "      Live Grep";
            opts.shortcut = "g";
            on_press.__raw = "function() vim.cmd[[Telescope live_grep]] end";
          }
          {
            type = "button";
            val = "      Quit";
            opts.shortcut = "q";
            on_press.__raw = "function() vim.cmd[[qa]] end";
          }
        ];
      }
      {
        type = "padding";
        val = 5;
      }
      {
        type = "text";
        val = "its neovim";
        opts.position = "center";
      }
    ];
  };
}
