{ inputs, lib, ... }:
{
  # You can break your inputs logically using flake-file.
  # Run "nix run .#write-flake" to generate the root flake-file using these definitions!
  flake-file.inputs.nix-flatpak.url = lib.mkDefault "github:gmodena/nix-flatpak";

  flake.modules.nixos.options-packaging =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      # The same module spec!
      options.packaging = lib.mkOption {
        type = lib.types.submodule {
          options = {
            flatpak.enable = lib.mkEnableOption "enable flatpak";
            appimage.enable = lib.mkEnableOption "enable appimage with sane defaults";
          };
        };
        default = { };
      };

      # This should be second nature by now.
      config = lib.mkMerge [
        (lib.mkIf config.packaging.flatpak.enable {
          services.flatpak.enable = true;
        })

        (lib.mkIf config.packaging.appimage.enable {
          programs.appimage.enable = true;
          programs.appimage.binfmt = true;
          programs.appimage.package = pkgs.appimage-run.override {
            extraPkgs =
              pkgs:
              builtins.attrValues {
                inherit (pkgs)
                  libxcrypt
                  icu
                  ;
              };
          };
        })
      ];
    };

  # See how effortless it was to put both "options-packaging" modules of separate
  # "nixos" and "homeManager" class in one file?
  flake.modules.homeManager.options-packaging =
    { lib, config, ... }:
    {
      # Home-manager modules can be imported as usual.
      imports = [
        inputs.nix-flatpak.homeManagerModules.nix-flatpak
      ];

      options.packaging = lib.mkOption {
        type = lib.types.submodule {
          options.flatpak.enableEssentials = lib.mkEnableOption "enable essential flatpak apps";
        };
        default = { };
      };

      # While we enabled the flatpak service in the nixos module, managing flatpak apps
      # via nix-flatpak is yet another breeze!
      config = lib.mkIf config.packaging.flatpak.enableEssentials {
        services.flatpak = {
          enable = true;
          remotes = lib.mkOptionDefault [
            # Let's enable flathub!
            {
              name = "flathub";
              location = "https://flathub.org/repo/flathub.flatpakrepo";
            }
          ];
          packages = [
            # Useful flatpak apps!
            "com.github.tchx84.Flatseal"
            "io.github.flattool.Warehouse"
          ];
          update.auto.enable = true;
          update.auto.onCalendar = "daily";
        };
      };
    };
}
