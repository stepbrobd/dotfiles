{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    shellWrapperName = "yy";

    plugins = with pkgs.yaziPlugins; {
      inherit full-border git nord yatline;
    };

    # pkgs.yaziPlugins.git
    settings.plugin.prepend_fetchers = [
      { group = "git"; url = "*"; run = "git"; }
      { group = "git"; url = "*/"; run = "git"; }
    ];

    initLua = /* lua */ ''
      -- pkgs.yaziPlugins.full-border
      require("full-border"):setup()

      -- pkgs.yaziPlugins.git
      require("git"):setup()

      -- pkgs.yaziPlugins.yatline
      require("yatline"):setup({
        -- pkgs.yaziPlugins.nord
        theme = require("nord"):setup(),

        display_header_line = false,

        status_line = {
          left = {
            section_a = {
              { type = "string", custom = false, name = "tab_mode", },
            },
            section_b = {
              { type = "string", custom = false, name = "hovered_size", },
            },
            section_c = {
              { type = "string", custom = false, name = "hovered_path", },
              { type = "coloreds", custom = false, name = "count", },
            },
          },
          right = {
            section_a = {
              { type = "string", custom = false, name = "cursor_position", },
            },
            section_b = {
              { type = "string", custom = false, name = "cursor_percentage", },
            },
            section_c = {
              { type = "string", custom = false, name = "hovered_file_extension", params = { true }, },
              { type = "coloreds", custom = false, name = "permissions", },
            },
          },
        },
      })
    '';
  };
}
