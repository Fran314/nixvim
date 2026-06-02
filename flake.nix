# Honestly this file is a bit of magic to me, I just accept that it works
{
  description = "Fran314's nixvim configuration";

  inputs = {
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
          # barbar.nvim carries the JSON license, which nixpkgs marks unfree.
          # Re-import nixvim's own nixpkgs (same revision) with a predicate that
          # allows just that one package. Setting allowUnfree on the pkgs passed
          # to makeNixvimWithModule is the working approach; see
          # https://github.com/nix-community/nixvim/issues/2147
          pkgs = import nixvim.inputs.nixpkgs {
            inherit system;
            config.allowUnfreePredicate =
              pkg: builtins.elem (nixvim.inputs.nixpkgs.lib.getName pkg) [ "barbar.nvim" ];
          };

          nvim = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs system;
            module = import ./config;
          };

          nvim-minimal = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs system;
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
