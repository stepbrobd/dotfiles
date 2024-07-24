{ stdenv
, prevPkgs
}:

if stdenv.isDarwin
then
  prevPkgs.spotify.overrideAttrs
    (_: {
      postInstall = ''
        rm -f $out/Applications/Spotify.app/Contents/Resources/Icon.icns
        cp ${./spotify.icns} $out/Applications/Spotify.app/Contents/Resources/Icon.icns
      '';
    })
else prevPkgs.spotify
