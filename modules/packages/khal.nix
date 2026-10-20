{ lib, inputs, ... }:
{
  flake-file.inputs.nixpkgs-1 = {
    url = lib.mkDefault "github:nixos/nixpkgs/fe13242281a67641c0102cdb1087f0ebe586c7df";
  };

  perSystem =
    { system, ... }:
    let
      pkgs-1 = import inputs.nixpkgs-1 {
        inherit system;
      };
    in
    {
      packages.khal = pkgs-1.khal;
    };
}
