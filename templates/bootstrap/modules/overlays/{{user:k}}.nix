{ inputs, moduleWithSystem, ... }:
let
  name = "{{user:k}}";
in
{
  # If you want to enable unfree software across the board, this is an easy way
  # to do so:
  #
  # perSystem =
  #   { system, ... }:
  #   {
  #     _module.args.pkgs = import inputs.nixpkgs {
  #       inherit system;
  #       config.allowUnfree = true;
  #     };
  #   };

  # flake-part's magical attribute merging does all the hard work!
  flake.modules.nixos."users-${name}" = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          # self'.packages holds all the packages from modules/packages.
          inherit (self'.packages)
            # ...the packages you want to use in modules of "nixos" class go here!
            ;
        })
      ];
    }
  );

  flake.modules.homeManager."users-${name}" = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          inherit (self'.packages)
            # ...the packages you want to use in modules of "homeManager" class go here!
            generate
            helium
            ;
        })
      ];
    }
  );
}
