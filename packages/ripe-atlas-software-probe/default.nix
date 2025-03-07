{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, openssl
, pkg-config
, user ? "ripe-atlas"
, group ? "ripe-atlas"
, measurement ? "ripe-atlas-measurement"
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ripe-atlas-software-probe";
  version = "5100";

  src = fetchFromGitHub {
    owner = "ripe-ncc";
    repo = "ripe-atlas-software-probe";
    tag = finalAttrs.version;
    hash = "sha256-n+SbjQoAf4Tnc52DNt5JFG9iyRBpeEuVtsewHnamgA8=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ openssl ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=format-security"
    "-Wno-error=implicit-function-declaration"
  ];

  configureFlags = [
    "--disable-chown"
    "--disable-systemd"
    "--disable-setcap-install"
    "--libdir=${placeholder "out"}/lib"
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--runstatedir=/run"
    "--with-user=${user}"
    "--with-group=${group}"
    "--with-measurement-user=${measurement}"
  ];

  meta = {
    broken = true;
    platforms = lib.platforms.linux;
  };
})
