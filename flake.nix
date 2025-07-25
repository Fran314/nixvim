# Honestly this file is a bit of magic to me, I just accept that it works
{
  description = "Fran314's nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { nixvim, flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { system, ... }:
        let
          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit system;
            module = import ./config;
          };

          nvim-minimal = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit system;
            module = import ./config/minimal.nix;
          };

        in
        {
          packages = {
            default = nvim;
            inherit nvim-minimal;
          };
        };
    };
}
