{
  lib,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs.nixpkgs-1.url = lib.mkDefault "github:nixos/nixpkgs/f9a75f41be3a74eab55d3a7679d34ad6cc0da977";

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
            codebook
            generate
            helium
            helix
            koji
            neuralrack
            niri-bibata-cursor-writer
            nix-output-monitor
            obs-studio
            oyui
            papirus-folders
            pinentry-dms
            prismlauncher
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
