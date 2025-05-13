{
  programs.yazi = {
    enable = true;

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
