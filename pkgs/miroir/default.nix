{ inputs
, stdenv
, makeWrapper
}:

let
  config = ../../repos/config.toml;
in
inputs.miroir.packages.${stdenv.hostPlatform.system}.default.overrideAttrs (prev: {
  nativeBuildInputs = prev.nativeBuildInputs or [ ] ++ [ makeWrapper ];
  postFixup = prev.postFixup or "" + ''
    wrapProgram $out/bin/${prev.meta.mainProgram} \
      --set MIROIR_CONFIG ${config}
  '';
})
