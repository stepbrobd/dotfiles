{ stdenv, pkgsPrev }:

if stdenv.hostPlatform.isDarwin
then
  pkgsPrev.neovide.overrideAttrs
    (prev: {
      postPatch = (prev.postPatch or "") + ''
        install -m644 ${./neovide.icns} extra/osx/Neovide.app/Contents/Resources/Neovide.icns
      '';
    })
else pkgsPrev.neovide
