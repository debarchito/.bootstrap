{
  inputs,
  lib,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs = {
    dms = {
      url = lib.mkDefault "github:duxlabs-dev/dux-shell";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    quickshell = {
      url = lib.mkDefault "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dgop = {
      url = lib.mkDefault "github:duxlabs-dev/dux-gop";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dsearch = {
      url = lib.mkDefault "github:duxlabs-dev/dux-search";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dfiles = {
      url = lib.mkDefault "github:duxlabs-dev/dux-files";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dcal = {
      url = lib.mkDefault "github:duxlabs-dev/dux-calendar";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
  };

  flake.modules.homeManager.options-desktop = moduleWithSystem (
    { system, ... }:
    { config, pkgs, ... }:
    {
      imports = [
        inputs.dms.homeModules.niri
        inputs.dms.homeModules.dank-material-shell
        inputs.dsearch.homeModules.default
        inputs.dfiles.homeModules.default
        inputs.dcal.homeModules.default
      ];

      config =
        let
          dankPlugins = {
            calculator = {
              rev = "a27b80ad8c3dd42da11af83461674fb362817515";
              hash = "sha256-fw5ySERKzK4iSzZhneIp06zFCP1FnxscbI/COzmPAGQ=";
            };
            commandRunner = {
              rev = "ea59490eede60d7dc87697b670f1eccc6ad54593";
              hash = "sha256-EmYYvPvSwG7ELTgRS6tcVEqFgyk8uYiB491Gp7nkPvs=";
            };
            emojiLauncher = {
              rev = "fc385900e6df292f0a7e5bdda4e3e37169897d7c";
              hash = "sha256-bIXdsoT3vKkrFI13G7tvRmhzJfjVmC3b3iuyRfafm9k=";
            };
            niriWindows = {
              rev = "411d5ee9f7707029f4c12c824ec3b24ca6756a0d";
              hash = "sha256-+Ju8cbw1yWWW2K2Gpl7nTdkjINqXBD4ktl5g8OhuIEg=";
            };
            webSearch = {
              rev = "8ec42a2dff96b94cdd0d40b57c1acd815c15079a";
              hash = "sha256-S1A50s7cKE0NuidC+x589wIxqGA6JW8GrCVEkCddMQs=";
            };
          };

          officialDMSRepository = pkgs.fetchFromGitHub {
            owner = "debarchito";
            repo = "dms-plugins";
            rev = "a55bb40da2f70640600a520ea05eac9c3540f1af";
            hash = "sha256-bwFkW+ki+CdjdpI5Pimuai3qMe7hnkp/N47YJfk24Y0=";
          };

          officialDMSPlugins = [
            "DankHooks"
            "DankKDEConnect"
            "DankNotepadModule"
          ];

          dankPinentryRepository = pkgs.fetchFromGitHub {
            owner = "debarchito";
            repo = "dankPinentry";
            rev = "02df8bceb651bdbc5fdc7a07b5f6f19e60c3906a";
            hash = "sha256-TmaRMZEHLatEjV5dIZqgEJMdqcK8CtG5mL++vWVlckg=";
          };

          dankPinentryPlugins = [
            "plugin"
          ];
        in
        lib.mkIf (config.desktop.niri.enable && config.desktop.niri.dms.enable) {
          nixpkgs.overlays = [
            inputs.quickshell.overlays.default
            (_: _: {
              dgop = inputs.dgop.packages.${system}.default;
            })
          ];

          programs = {
            dank-material-shell = {
              enable = true;
              quickshell.package = pkgs.quickshell;
              niri.includes.enable = false;
              plugins =
                (lib.mapAttrs (name: value: {
                  src = pkgs.fetchFromGitHub {
                    owner = "debarchito";
                    repo = name;
                    inherit (value) rev hash;
                  };
                }) dankPlugins)
                // (lib.genAttrs officialDMSPlugins (name: {
                  src = "${officialDMSRepository}/${name}";
                }))
                // (lib.genAttrs dankPinentryPlugins (name: {
                  src = "${dankPinentryRepository}/${name}";
                }));
            };
            dsearch.enable = true;
            dux-files.enable = true;
            dank-calendar = {
              enable = true;
              quickshell.package = pkgs.quickshell;
            };
          };

          home.packages = builtins.attrValues {
            inherit (pkgs)
              dgop
              ;
          };

          xdg.configFile = {
            "DankMaterialShell/settings.json".source = ./dank-material-shell/settings.json;
            "DankMaterialShell/plugin_settings.json".source = ./dank-material-shell/plugin_settings.json;
          };
        };
    }
  );
}
