{
  programs.lsd = {
    enable = true;
    settings = {
      icons.when = "auto";
      sorting.dir-grouping = "first";
      no-symlink = true;

      ignore-globs = [
        ".DS_Store"
        ".direnv"
        ".git"
        ".jj"
      ];
    };
  };
}
