{ config
, lib
, pkgs
, ...
}:

{
  age.secrets.pgp.file = ../../secrets/pgp.age;
  home.activation = {
    importPGPKeys =
      let
        replace =
          if pkgs.stdenv.isLinux
          then builtins.replaceStrings [ "$XDG_RUNTIME_DIR" ] [ "\${XDG_RUNTIME_DIR}" ]
          else if pkgs.stdenv.isDarwin
          then builtins.replaceStrings [ "$(getconf DARWIN_USER_TEMP_DIR)" ] [ "\${$(getconf DARWIN_USER_TEMP_DIR)}" ]
          else abort "Unsupported OS";
        path = replace config.age.secrets.pgp.path;
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.gnupg}/bin/gpg --import ${path}
      '';
  };
}
