{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "monocle";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "bgpkit";
    repo = "monocle";
    tag = "v${version}";
    hash = "sha256-vpGCYU/vW4cQFuAWxa+ZkuKLB4NSs5tPW2iWVE8iPAk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1wouA1REbPHm/v4ZB76gfgDPweNV3nztf6XxKdu42GQ=";

  meta = {
    description = "See through all BGP data with a monocle";
    homepage = "https://github.com/bgpkit/monocle";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "monocle";
  };
}
