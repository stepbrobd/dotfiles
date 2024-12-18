{
  programs.lsd = {
    enable = true;
    settings = {
      icons.when = "auto";
      sorting.dir-grouping = "first";
      ignore-globs = [
        ".DS_Store"
        ".git"
        ".spacedrive"
      ];
    };
  };
}
