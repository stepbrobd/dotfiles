{ stdenv
, pkgs
, prevPkgs ? pkgs # `prevPkgs` only provided in overlays
}:

if stdenv.isDarwin
then
  prevPkgs.alacritty.overrideAttrs
    (oldAttrs: {
      postInstall = oldAttrs.postInstall
        + ''
        rm -f $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns
        cp ${./alacritty.icns} $out/Applications/Alacritty.app/Contents/Resources/alacritty.icns
      '';
    })
else prevPkgs.alacritty
