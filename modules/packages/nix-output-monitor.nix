{ lib, inputs, ... }:
{
  flake-file.inputs.nix-output-monitor = {
    url = lib.mkDefault "github:maralorn/nix-output-monitor/202f940f96360548dedfb3b9234f6f6f08a9a2ba";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  perSystem =
    { system, ... }:
    {
      packages.nix-output-monitor = inputs.nix-output-monitor.packages.${system}.default;
    };
}
