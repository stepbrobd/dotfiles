# https://github.com/nix-community/nixvim

{ stdenv
, pkgs
, inputs
, ...
}:

inputs.nixvim.legacyPackages."${stdenv.hostPlatform.system}".makeNixvim {
  colorschemes.nord.enable = true;

  options = {
    encoding = "utf-8";
    title = true;
    wrap = false;
    number = true;
    relativenumber = true;
    clipboard = "unnamedplus";
    incsearch = true;
    ignorecase = true;
    smartcase = true;
    expandtab = true;
    undofile = true;
    autoindent = true;
    smartindent = true;
    smarttab = true;
  };

  plugins.lazy = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      {
        pkg = alpha-nvim;
        dependencies = [ nvim-web-devicons telescope-nvim ];
        config = ''
          function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            -- Set header
            dashboard.section.header.val = {
              [[     ███████╗███╗   ███╗ █████╗  ██████╗███████╗    ]],
              [[     ██╔════╝████╗ ████║██╔══██╗██╔════╝██╔════╝    ]],
              [[     █████╗  ██╔████╔██║███████║██║     ███████╗    ]],
              [[     ██╔══╝  ██║╚██╔╝██║██╔══██║██║     ╚════██║    ]],
              [[     ███████╗██║ ╚═╝ ██║██║  ██║╚██████╗███████║    ]],
              [[     ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝╚══════╝    ]],
            }
            -- Set menu
            dashboard.section.buttons.val = {
              dashboard.button("n", "  New File", ":ene <BAR> startinsert <CR>"),
              dashboard.button("f", "  Find File", ":Telescope find_files <CR>"),
              dashboard.button("g", "󰱼  Live Grep", ":Telescope live_grep <CR>"),
              dashboard.button("q", "  Quit", ":qa<CR>"),
            }
            alpha.setup(dashboard.opts)
          end
        '';
      }
      {
        pkg = Coqtail;
      }
    ];
  };
}
