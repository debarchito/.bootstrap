{ lib, ... }:
{
  flake-file.inputs.home-manager = {
    url = lib.mkDefault "github:nix-community/home-manager";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };
}
