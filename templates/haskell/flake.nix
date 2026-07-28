{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    haskell-flake.url = "github:srid/haskell-flake";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-parts,
      haskell-flake,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        flake-parts.flakeModules.easyOverlay
        treefmt-nix.flakeModule
        haskell-flake.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        {
          pkgs,
          config,
          self',
          ...
        }:
        {
          haskellProjects.default = {
            basePackages = pkgs.haskell.packages.ghc910;

            autoWire = [
              "packages"
              "apps"
              "checks"
            ];

            devShell.hlsCheck.enable = false;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              ormolu.enable = true;
              hlint.enable = true;
            };
          };

          packages.default = self'.packages.{{name:k}};

          overlayAttrs = rec {
            inherit (self'.packages) default;
            {{name:k}} = default;
          };

          devShells.default = pkgs.mkShell {
            name = "{{name:k}}-dev";

            inputsFrom = [
              config.haskellProjects.default.outputs.devShell
            ];
          };
        };
    };
}
