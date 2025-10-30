{ lib
, stdenv
}:

(lib.getFlake "github:hraban/mac-app-util/8414fa1e2cb775b17793104a9095aabeeada63ef").packages.${stdenv.hostPlatform.system}.default.overrideAttrs {
  meta = {
    platforms = lib.platforms.darwin;
    badPlatforms = lib.platforms.linux;
  };
}
