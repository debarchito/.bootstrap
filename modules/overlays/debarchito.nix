{ inputs, moduleWithSystem, ... }:
{
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };

  flake.modules.nixos.users-debarchito = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          inherit (self'.packages)
            nix-output-monitor
            waydroid-choose-gpu
            waydroid-script
            ;
        })
      ];
    }
  );

  flake.modules.homeManager.users-debarchito = moduleWithSystem (
    { self', ... }:
    {
      nixpkgs.overlays = [
        (_: prev: {
          inherit (self'.packages)
            blender
            bottles
            calculate-hash-section
            generate
            helium
            helix
            neuralrack
            nix-output-monitor
            obs-studio
            papirus-folders
            pinentry-dms
            prismlauncher-unwrapped
            qt6ct
            ratatouille
            reaper
            sioyek
            tone3000
            wiiudownloader
            ;
        })
      ];
    }
  );
}
