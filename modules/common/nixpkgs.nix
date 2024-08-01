# nixpkgs + nix-darwin options

{ inputs, ... }:

{
  nixpkgs.config = {
    # contentAddressedByDefault = true;
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  nixpkgs.overlays = [ inputs.self.overlays.default ];
}
