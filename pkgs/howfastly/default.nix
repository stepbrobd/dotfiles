{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "howfastly";
  version = "2026.813.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "howfastly";
    tag = finalAttrs.version;
    hash = "sha256-q9xg++7S80AgHvpZalyb7VU7Ns66dgbkKQzbzjj0zSo=";
  };

  cargoHash = "sha256-frgRoYxMMCVre7ACxc6wUgkdqPyutkfTemwV2Yv8jko=";

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
