{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule (finalAttrs: {
  pname = "stackwhere";
  version = "0.3.2";

  passthru.autobump = true;

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "stackwhere";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g1CnWA8WNRHaGXMm+Ksi3AnkFJCy9/bjQbhYjrOlu1M=";
  };

  vendorHash = "sha256-J2X1uTkRtmdmo8Fxxql6Nu84F6MarWHFTopavUPL+RU=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  meta = {
    description = "A tool for exploring where BPF stack usage comes from";
    homepage = "https://github.com/cilium/stackwhere";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "stackwhere";
  };
})
