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
  version = "5110";

  src = fetchFromGitHub {
    owner = "ripe-ncc";
    repo = "ripe-atlas-software-probe";
    tag = finalAttrs.version;
    hash = "sha256-PH4mdz7OGYpS5KwXVbH7PV+DI3y8MG7uzXXMKnGrJ24=";
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
