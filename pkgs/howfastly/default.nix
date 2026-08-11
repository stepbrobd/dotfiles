{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "howfastly";
  version = "2026.810.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "howfastly";
    tag = finalAttrs.version;
    hash = "sha256-qLYns63RLE5Tozua4F/qvOE1qtrkc0psHfgZIvNr1rA=";
  };

  cargoHash = "sha256-Cq3e3KmtfTt2KUS+TKg5LR3JXVw/6DGtaK8ucyPxdYU=";

  nativeBuildInputs = [ pkg-config ];

  cargoBuildFlags = [ "--package" "howfastly" ];

  doCheck = false;

  passthru.autobump = true;

  meta = {
    description = "How fast is your connection to the Fastly network";
    homepage = "https://github.com/stepbrobd/howfastly";
    changelog = "https://github.com/stepbrobd/howfastly/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "howfastly";
  };
})
