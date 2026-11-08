{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs-1 = import inputs.nixpkgs-1 {
        inherit system;
      };
    in
    {
      packages.oyui = pkgs-1.oyui;
    };
}
