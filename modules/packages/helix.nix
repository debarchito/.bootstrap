{ lib, inputs, ... }:
{
  flake-file.inputs.helix = {
    url = lib.mkDefault "github:debarchito/helix/steel-event-system";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  perSystem =
    { system, ... }:
    {
      packages.helix = inputs.helix.packages.${system}.default.overrideAttrs (oldAttrs: {
        cargoBuildFlags = (oldAttrs.cargoBuildFlags or [ ]) ++ [
          "--features"
          "steel,git"
        ];
      });
    };
}
