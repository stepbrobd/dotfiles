{ stdenvNoCC
, fetchFromGitHub
, makeBinaryWrapper
, nodejs
, yarn-berry
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "neogrok";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "isker";
    repo = "neogrok";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xAfXT2QioNKHL25lEAlryeaO3JUfOAIMW2+jaobvukY=";
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit nodejs;
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-WtA0wNn3UwDIb85YJhkCubvWrXab+T9tiz6yerdUblM=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    yarn build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/neogrok}
    cp -r build node_modules main.js package.json $out/lib/neogrok/

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/neogrok \
      --add-flags $out/lib/neogrok/main.js

    runHook postInstall
  '';

  meta.mainProgram = "neogrok";
})
