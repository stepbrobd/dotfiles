# https://github.com/wandersoncferreira/dotfiles/commit/6ddc35f7d36810abec9add929b075287bb656488#diff-0b30ec4f825bea4741da227a1f17a757cd40a5e19c0ffb5bf49c405545f8c3fc

{ lib
, alsa-lib
, at-spi2-atk
, at-spi2-core
, atk
, c-ares
, cairo
, cups
, dbus
, expat
, fetchurl
, ffmpeg
, gdk-pixbuf
, glib
, gtk3-x11
, http-parser
, libappindicator-gtk2
, libappindicator-gtk3
, libdrm
, libevent
, libnotify
, libvpx
, libxslt
, makeWrapper
, mesa
, nspr
, nss
, pango
, squashfsTools
, stdenv
, systemd
, xorg
}:

let
  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    c-ares
    cairo
    cups
    dbus
    expat
    ffmpeg
    gdk-pixbuf
    glib
    gtk3-x11
    http-parser
    libappindicator-gtk2
    libappindicator-gtk3
    libdrm
    libevent
    libnotify
    libvpx
    libxslt
    mesa
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
  ];
  rev = "10";

in

stdenv.mkDerivation {
  pname = "hey-mail";
  version = "1.2.16";

  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/lfWUNpR7PrPGsDfuxIhVxbj0wZHoH7bK_${rev}.snap";
    hash = "sha256-T70fTMob/ivQxXxd8YdFnyzlPPX9ZvjqFV3juBC/x84=";
  };

  nativeBuildInputs = [
    squashfsTools
    makeWrapper
  ];

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src"
    cd squashfs-root
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib $out/share/applications/ $out/share/icons/
    mv ./* $out/

    ln -s $out/meta/snap.yaml $out/snap.yaml

    rpath="$out"

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $rpath $out/hey-mail

    librarypath="${lib.makeLibraryPath deps}"

    wrapProgram $out/hey-mail \
      --prefix LD_LIBRARY_PATH : "$librarypath" \
      --prefix PATH : $out/bin \
      --append-flags '--in-process-gpu'

    install -Dm755 $out/hey-mail $out/bin/hey-mail

    # fix icon line in the desktop file
    sed -i "s:^Icon=.*:Icon=hey-mail:" "$out/meta/gui/hey-mail.desktop"

    # desktop file
    cp "$out/meta/gui/hey-mail.desktop" "$out/share/applications/"

    # icon
    ln -s "$out/meta/gui/icon.png" "$out/share/icons/hey-mail.png"

    runHook postInstall
  '';

  meta = {
    homepage = "https://hey.com";
    description = "Read your e-mails on HEY Mail desktop app";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = [ "x86_64-linux" ];
  };
}
