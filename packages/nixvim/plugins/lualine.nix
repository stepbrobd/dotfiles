{
  plugins.lualine = {
    enable = true;
    settings = {
      extensions = [
        "toggleterm"
      ];

      options = {
        theme = "nord";
        icons_enabled = true;
      };
      sections = {
        lualine_a = [ "mode" ];
        lualine_b = [ "branch" ];
        lualine_c = [ "diff" "diagnostics" ];
        lualine_x = [ "filetype" "encoding" ];
        lualine_y = [ "progress" ];
        lualine_z = [ "location" ];
      };
    };
  };
}
