{
  inputs,
  lib,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs = {
    dms = {
      url = lib.mkDefault "github:AvengeMedia/DankMaterialShell/v1.6.2";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    quickshell = {
      url = lib.mkDefault "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dgop = {
      url = lib.mkDefault "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dsearch = {
      url = lib.mkDefault "github:AvengeMedia/danksearch";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    dcal = {
      url = lib.mkDefault "github:AvengeMedia/dankcalendar";
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
        inputs.dcal.homeModules.default
      ];

      config =
        let
          dankPlugins = {
            batteryPlus = {
              rev = "4e653d09174e1edc260f279c42ec2477b6fb2e24";
              hash = "sha256-XEAvnTisFTPs55+uVCDeHXSJthtkE0CU6No29TDyAYY=";
            };
            calculator = {
              rev = "1db5865419a40a33171a475855a59e0b8bf7187f";
              hash = "sha256-j8C62+sevr6b+akzVSAqUVysIhb6Vbr8jnWcTXeOtE8=";
            };
            commandRunner = {
              rev = "35277695de06beadaba701cb94cc8b096b233319";
              hash = "sha256-o43IyVT901ZzZGDvZKWhlrgMba57thAoqL3+BFaFV74=";
            };
            dockerManager = {
              rev = "9e6a01283e169c46eff7a157202b1b8ab48577b1";
              hash = "sha256-tJjJaevs4iKfiGMIA05fmNtCCKrH+r+QZyvQRo9Okqg=";
            };
            emojiLauncher = {
              rev = "1c0a7d337a52b48f9499060076703a35e8dd4f4f";
              hash = "sha256-NQ14YenDiNK2VqXQ3z7jAkatbSRtYJHhOhvv7AJlUD8=";
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
            rev = "bb90a1db7d540e64ae049c5906afba9b24baa865";
            hash = "sha256-NYmw2wCZYAKNU1xcodKMDXs5wwtAguOUNazRxcLjsUE=";
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

          xdg.configFile =
            let
              vars.USERNAME = config.home.username;
            in
            {
              "DankMaterialShell/settings.json".source = ./dank-material-shell/settings.json;
              "DankMaterialShell/plugin_settings.json".source =
                pkgs.replaceVars ./dank-material-shell/plugin_settings.json vars;
            };
        };
    }
  );
}
