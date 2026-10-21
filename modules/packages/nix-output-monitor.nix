{ lib, inputs, ... }:
{
  flake-file.inputs.nix-output-monitor = {
    url = lib.mkDefault "github:maralorn/nix-output-monitor";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  perSystem =
    { system, ... }:
    {
      packages.nix-output-monitor = inputs.nix-output-monitor.packages.${system}.default;
    };
}
