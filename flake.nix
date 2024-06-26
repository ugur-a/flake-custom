{
  description = "all of the custom stuff I reexport into the main flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
  # System-specific outputs
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        # My custom packages, available through 'nix build', 'nix shell', etc
        legacyPackages = import ./pkgs/legacy {inherit pkgs;};

        # My custom modules
        nixosModules = import ./modules/nixos;
        homeManagerModules = import ./modules/home;

        # My custom overlays
        overlays = import ./overlays {inherit inputs;};
      }
    )
    # System-independent ouputs
    // {
      templates = import ./templates;
    };
}
