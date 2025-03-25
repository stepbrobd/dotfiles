{
  programs.lsd = {
    enable = true;
    settings = {
      icons.when = "auto";
      sorting.dir-grouping = "first";

      no-symlink = true;
      total-size = true;

      ignore-globs = [
        ".DS_Store"
        ".direnv"
        ".git"
        ".jj"
      ];
    };
  };
}
