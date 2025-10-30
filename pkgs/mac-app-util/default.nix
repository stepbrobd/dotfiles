{ lib
, stdenv
}:

# https://github.com/hraban/mac-app-util
(builtins.getFlake "github:hraban/mac-app-util/8414fa1e2cb775b17793104a9095aabeeada63ef").packages.${stdenv.hostPlatform.system}.default.overrideAttrs {
  meta = {
    mainProgram = "mac-app-util";
    platforms = lib.platforms.darwin;
    badPlatforms = lib.platforms.linux;
  };
}
