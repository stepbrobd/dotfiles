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
    rev = "10190106b083efd12e411484bdd8d1d48da36422";
    hash = "sha256-MCsI1EZxg/5pSi+PjBPdIPooaFYjjbnW6nOrMbc1ePM=";
  };

  vendorHash = "sha256-4orp8iQekVbhCFpt7DXLvj6dediKxo1qkWr1oe7+RaE=";
}
