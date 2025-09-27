{ stdenv
, pkgs
, pkgsPrev ? pkgs # `pkgsPrev` only provided in overlays
}:

if stdenv.isDarwin
then
  pkgsPrev.spotify.overrideAttrs
    (_: {
      postInstall = ''
        rm -f $out/Applications/Spotify.app/Contents/Resources/Icon.icns
        cp ${./spotify.icns} $out/Applications/Spotify.app/Contents/Resources/Icon.icns
      '';
    })
else pkgsPrev.spotify
