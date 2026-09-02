{ lib
, rustPlatform
, fetchFromGitHub
, versionCheckHook
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "howfastly";
  version = "2026.901.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "howfastly";
    tag = finalAttrs.version;
    hash = "sha256-pyvc9LnlxRi9pJjiDqVSqkc+r2bIQCIRZaqU9xmNgzs=";
  };

  cargoHash = "sha256-Jvu9xdOtdpbSVz3OZ02n7q1MczkccYGZls9Kbz9HvGE=";

  cargoBuildFlags = [ "--package" "howfastly" ];

  useNextest = true;
  cargoTestFlags = [ "--package" "howfastly" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--help";

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
