{ stdenvNoCC
, fetchzip
, fontforge
, nerd-font-patcher
, writeShellApplication
}:

let
  # stole from
  # https://github.com/saksmt/nix-config/blob/7e52694dae5cc9fc41e23ce928c73ca070ffd14a/package-sets/gui/setup/fonts.nix#L34
  patcher = writeShellApplication {
    name = "nerd-patch";
    runtimeInputs = [ nerd-font-patcher fontforge ];
    text = ''
      read -r -a patchArgs <<< "''${FONT_PATCH_ARGS:--c}"
      sourceFont="''${1}"
      sourceFontDir="$(dirname "''${sourceFont}")"
      sourceFontFile="$(basename "''${sourceFont}")"
      targetName="''${sourceFontFile%.*}-nf.''${sourceFontFile##*.}"

      cd "''${sourceFontDir}"

      echo "Patching ''${sourceFontFile}, will write it as ''${targetName}" >&2
      nerd-font-patcher "''${patchArgs[@]}" "''${sourceFontFile}" || { echo "Failed patching. Args: ''${patchArgs[*]} ''${sourceFontFile}">&2; exit 1; }
      mv "''${sourceFontFile}" "''${targetName}"
    '';
  };
  nerdify =
    font:
    stdenvNoCC.mkDerivation {
      name = "${font.name}-nf";
      src = font;
      nativeBuildInputs = [ patcher ];
      buildPhase = ''
        export FONT_PATCH_ARGS="-cq --makegroups 4"
        # for some unholy unknown reason find -exec does not work here...
        find . -name '*.ttf' -o -name '*.otf' | xargs -P''${NIX_BUILD_CORES:-1} -n1 nerd-patch
      '';
      installPhase = "cp -a . $out";
    };
  pixelmplus = stdenvNoCC.mkDerivation {
    pname = "pixelmplus";
    version = "1.0.0";
    src = fetchzip {
      url = "https://github.com/itouhiro/pixelmplus/releases/download/v1.0.0/PixelMplus-20130602.zip";
      hash = "sha256-bcXXBLxpH8EheWBCWX0OlS6rt/8i7k5tLfeYxu0d1xU=";
    };
    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/fonts/truetype/pixelmfonts/
      find . -name '*.ttf' -exec install -m444 -Dt $out/share/fonts/pixelmfonts/ {} \;

      runHook postInstall
    '';
  };
in
nerdify pixelmplus
