{ pkgsPrev, fetchFromGitHub }:

(pkgsPrev.tailscale.override {
  buildGoModule = pkgsPrev.buildGoModule.override {
    go = pkgsPrev.go_1_26.overrideAttrs {
      version = "1.26.1";

      src = fetchFromGitHub {
        owner = "tailscale";
        repo = "go";
        rev = "0f1a3326f30508521e7b8322f4e0f084560c1404";
        hash = "sha256-zyo1dIQnrwq8TVxwKCjJ3PfiShjAXO4wMQb/F7ze/mU=";
      };
    };
  };
}).overrideAttrs {
  version = "1.95.161+18781";

  src = fetchFromGitHub {
    owner = "stepbrobd";
    repo = "tailscale";
    rev = "e0cdacd4060cdd62a1f986fc5e6f577b9cfbf29f";
    hash = "sha256-IzekKxsRqjCzc+XIGQvV0qWperIe9p86kVQIq+RzwA4=";
  };

  vendorHash = "sha256-dx+SJyDx+eZptFaMatoyM6w1E3nJKY+hKs7nuR997bE=";
}
