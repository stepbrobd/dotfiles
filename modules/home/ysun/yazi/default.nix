{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;

    plugins = with pkgs.yaziPlugins; {
      inherit full-border git yatline;
    };

    initLua = /* lua */ ''
      -- pkgs.yaziPlugins.full-border
      require("full-border"):setup()

      -- pkgs.yaziPlugins.git
      require("git"):setup()

      -- pkgs.yaziPlugins.yatline
      require("yatline"):setup({
        header_line = {
          left = {
            section_a = {
              { type = "line", custom = false, name = "tabs", params = { "left" }, },
            },
            section_b = { },
            section_c = { },
          },
          right = {
            section_a = {
              { type = "coloreds", custom = false, name = "count", params = "true" },
            },
            section_b = { },
            section_c = { },
          }
        },

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

        theme = {
          section_separator = { open = "", close = "" },
          part_separator = { open = "", close = "" },
          inverse_separator = { open = "", close = "" },

          style_a = {
                  fg = "black",
                  bg_mode = {
                          normal = "#81A1C1",
                          select = "#88C0D0",
                          un_set = "#D08770"
                  }
          },
          style_b = { bg = "#4C566A", fg = "#E5E9F0" },
          style_c = { bg = "#3B4252", fg = "#81A1C1" },

          permissions_t_fg = "#A3BE8C",
          permissions_r_fg = "#EBCB8B",
          permissions_w_fg = "#BF616A",
          permissions_x_fg = "#88C0D0",
          permissions_s_fg = "#E5E9F0",

          selected = { icon = "󰻭", fg = "#EBCB8B" },
          copied = { icon = "", fg = "#A3BE8C" },
          cut = { icon = "", fg = "#BF616A" },
          files = { icon = "", fg = "#5E81AC" },
          filtereds = { icon = "", fg = "#B48EAD" },

          total = { icon = "󰮍", fg = "#EBCB8B" },
          succ = { icon = "", fg = "#A3BE8C" },
          fail = { icon = "", fg = "#BF616A" },
          found = { icon = "󰮕", fg = "#5E81AC" },
          processed = { icon = "󰐍", fg = "#A3BE8C" },
        },
      })
    '';

    # pkgs.yaziPlugins.git
    settings.plugin.prepend_fetchers = [
      { id = "git"; name = "*"; run = "git"; }
      { id = "git"; name = "*/"; run = "git"; }
    ];

    theme = {
      cmp = {
        border = {
          fg = "#81A1C1";
        };
      };
      filetype = {
        rules = [
          {
            fg = "#88C0D0";
            mime = "image/*";
          }
          {
            fg = "#EBCB8B";
            mime = "{audio,video}/*";
          }
          {
            fg = "#B48EAD";
            mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}";
          }
          {
            fg = "#A3BE8C";
            mime = "application/{pdf,doc,rtf}";
          }
          {
            fg = "#E5E9F0";
            name = "*";
          }
          {
            fg = "#81A1C1";
            name = "*/";
          }
        ];
      };
      help = {
        footer = {
          bg = "#E5E9F0";
          fg = "#3B4252";
        };
        hovered = {
          bold = true;
          reversed = true;
        };
        on = {
          fg = "#88C0D0";
        };
        run = {
          fg = "#B48EAD";
        };
      };
      input = {
        border = {
          fg = "#81A1C1";
        };
        selected = {
          reversed = true;
        };
        title = { };
        value = { };
      };
      manager = {
        border_style = {
          fg = "#4C566A";
        };
        border_symbol = "│";
        count_copied = {
          bg = "#A3BE8C";
          fg = "#2E3440";
        };
        count_cut = {
          bg = "#BF616A";
          fg = "#2E3440";
        };
        count_selected = {
          bg = "#EBCB8B";
          fg = "#2E3440";
        };
        cwd = {
          fg = "#88C0D0";
        };
        find_keyword = {
          bold = true;
          fg = "#EBCB8B";
          italic = true;
          underline = true;
        };
        find_position = {
          bg = "reset";
          bold = true;
          fg = "#B48EAD";
          italic = true;
        };
        hovered = {
          reversed = true;
        };
        marker_copied = {
          bg = "#A3BE8C";
          fg = "#A3BE8C";
        };
        marker_cut = {
          bg = "#BF616A";
          fg = "#BF616A";
        };
        marker_marked = {
          bg = "#88C0D0";
          fg = "#88C0D0";
        };
        marker_selected = {
          bg = "#EBCB8B";
          fg = "#EBCB8B";
        };
        preview_hovered = {
          underline = true;
        };
        tab_active = {
          reversed = true;
        };
        tab_inactive = { };
        tab_width = 1;
      };
      mode = {
        normal_alt = {
          bg = "#3B4252";
          fg = "#81A1C1";
        };
        normal_main = {
          bg = "#81A1C1";
          bold = true;
          fg = "#2E3440";
        };
        select_alt = {
          bg = "#3B4252";
          fg = "#88C0D0";
        };
        select_main = {
          bg = "#88C0D0";
          bold = true;
          fg = "#2E3440";
        };
        unset_alt = {
          bg = "#3B4252";
          fg = "#D08770";
        };
        unset_main = {
          bg = "#D08770";
          bold = true;
          fg = "#2E3440";
        };
      };
      notify = {
        title_error = {
          fg = "#BF616A";
        };
        title_info = {
          fg = "#A3BE8C";
        };
        title_warn = {
          fg = "#EBCB8B";
        };
      };
      pick = {
        active = {
          bold = true;
          fg = "#B48EAD";
        };
        border = {
          fg = "#81A1C1";
        };
        inactive = { };
      };
      status = {
        perm_exec = {
          fg = "#A3BE8C";
        };
        perm_read = {
          fg = "#EBCB8B";
        };
        perm_sep = {
          fg = "#4C566A";
        };
        perm_type = {
          fg = "#81A1C1";
        };
        perm_write = {
          fg = "#BF616A";
        };
        progress_error = {
          bg = "#434C5E";
          fg = "#BF616A";
        };
        progress_label = {
          bold = true;
          fg = "#E5E9F0";
        };
        progress_normal = {
          bg = "#434C5E";
          fg = "#81A1C1";
        };
      };
      tasks = {
        border = {
          fg = "#81A1C1";
        };
        hovered = {
          fg = "#B48EAD";
          underline = true;
        };
        title = { };
      };
      which = {
        cand = {
          fg = "#88C0D0";
        };
        desc = {
          fg = "#B48EAD";
        };
        mask = {
          bg = "#3B4252";
        };
        rest = {
          fg = "#5E81AC";
        };
        separator = "  ";
        separator_style = {
          fg = "#4C566A";
        };
      };
    };
  };
}
