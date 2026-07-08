{
  # Feature modules use the "options-" prefix by convention.
  flake.modules.nixos.options-common =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      # Fully qualified module definitions are preferred!
      options.common = lib.mkOption {
        type = lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "common settings that can be shared between multiple hosts";
            desktop.enable = lib.mkEnableOption "desktop specific common settings";
            flake = lib.mkOption {
              type = lib.types.str;
              default = "/etc/nixos";
              description = "path to the flake to use";
            };
            gc.arguments = lib.mkOption {
              type = lib.types.str;
              default = "--delete-older-than 7d --keep 2";
              description = "additional options for garbage collection";
            };
          };
        };
        # Fully qualified definitions allow you to do assign default options easily!
        # For this module, we'll keep it empty.
        default = { };
      };

      # This format should be familiar to you if you've ever used custom options in the past!
      config = lib.mkIf config.common.enable (
        # This is a demo of how you could go about composing such options.
        lib.mkMerge [
          {
            services.fail2ban.enable = true;

            nix.settings = {
              experimental-features = [
                "nix-command"
                "flakes"
                # Did you know Nix had experimental pipe operators?
                "pipe-operators"
              ];
              auto-optimise-store = true;
            };

            programs = {
              nix-ld.enable = true;
              nh = {
                enable = true;
                inherit (config.common) flake;
                clean = {
                  enable = true;
                  extraArgs = config.common.gc.arguments;
                };
              };
            };
          }

          # Options that are generally useful for desktops!
          (lib.mkIf config.common.desktop.enable {
            security = {
              polkit.enable = true;
              rtkit.enable = true;
            };

            services = {
              accounts-daemon.enable = true;
              avahi.enable = true;
              colord.enable = true;
              fwupd.enable = true;
              power-profiles-daemon.enable = true;
              printing.enable = true;
              upower.enable = true;
            };

            # No with-expression please! It's 2026+ already.
            environment.systemPackages = builtins.attrValues {
              inherit (pkgs)
                cups-pk-helper
                ;
            };
          })
        ]
      );
    };
}
