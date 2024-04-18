{ inputs, outputs }:

let
  inherit (outputs) lib;
in
final: prev:
(
  lib.mkDynamicAttrs
    {
      dir = ../packages;
      fun = name: lib.importPackagesWith {
        pkgs = final;
        file = (../packages/. + "/${name}");
        args = { };
      };
    }
    // lib.optionalAttrs prev.stdenv.isDarwin {
    alacritty = prev.alacritty.overrideAttrs (oldAttrs: {
      postInstall =
        let
          icon = ./alacritty.icns;
        in
        prev.alacritty.postInstall
        + ''
          rm -f $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns
          cp ${icon} $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns
        '';
    });

    spotify = prev.spotify.overrideAttrs (oldAttrs: {
      postInstall =
        let
          icon = ./spotify.icns;
        in
        ''
          rm -f $out/Applications/Spotify.app/Contents/Resources/Icon.icns
          cp ${icon} $out/Applications/Spotify.app/Contents/Resources/Icon.icns
        '';
    });
  }
)
