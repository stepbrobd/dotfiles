{ config, ... }:

{
  home.preferXdgDirectories = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      setSessionVariables = true;
      createDirectories = true;
    };
  };

  # check with pkgs.xdg-ninja
  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    CHECKPOINT_DISABLE = "1";
    DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
    MPLCONFIGDIR = "${config.xdg.cacheHome}/matplotlib";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
    SQLITE_HISTORY = "${config.xdg.stateHome}/sqlite_history";
  };

  # cursor is linked into $XDG_DATA_HOME/icons
  home.pointerCursor.dotIcons.enable = false;

  # ~/.themes only exists for flatpak apps
  stylix.targets.gtk.flatpakSupport.enable = false;
}
