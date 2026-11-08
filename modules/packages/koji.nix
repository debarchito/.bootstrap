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
      packages.koji = pkgs-1.koji;
    };
}
