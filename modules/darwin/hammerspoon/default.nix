{ pkgs, ... }:

let inherit (pkgs) lib; in
{
  config = lib.mkIf pkgs.stdenv.isDarwin {
    homebrew.casks = [ "hammerspoon" ];

    # https://github.com/nmasur/dotfiles/blob/4883532c65383c2615047bd1bb3ed5cf606f996e/modules/darwin/hammerspoon.nix
    system.activationScripts.postUserActivation.text = ''
      defaults write org.hammerspoon.Hammerspoon MJConfigFile "${./init.lua}"

      # if [ -e /Applications/Hammerspoon.app/Contents/Frameworks/hs/hs ]; then
      #   /Applications/Hammerspoon.app/Contents/Frameworks/hs/hs -c 'hs.reload()'
      #   /Applications/Hammerspoon.app/Contents/Frameworks/hs/hs -c 'hs.console.clearConsole()'
      # fi

      sudo killall Dock
    '';
  };
}
