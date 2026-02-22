{ pkgsPrev, fetchFromGitHub }:

(pkgsPrev.tailscale.override {
  buildGoModule = pkgsPrev.buildGoModule.override {
    go = pkgsPrev.go_1_25.overrideAttrs {
      version = "1.25.7";

      src = fetchFromGitHub {
        owner = "tailscale";
        repo = "go";
        rev = "692441891e061f8ae2cb2f8f2c898f86bb1c5dca";
        hash = "sha256-gWKrpBTXfsQmgOWoMrbvCaWGsBXCt5X12BAcwfAPMQY=";
      };
    };
  };
}).overrideAttrs {
  version = "1.95.0+18781";

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "tailscale";
    rev = "ce2ef6937fea38860917b3d42f7fd9293c9aff63";
    hash = "sha256-CeCxizOzddUJJqZMzcMF5gtaRGkS9o+/Mh+wvbGPtOk=";
  };

  vendorHash = "sha256-4orp8iQekVbhCFpt7DXLvj6dediKxo1qkWr1oe7+RaE=";
}
