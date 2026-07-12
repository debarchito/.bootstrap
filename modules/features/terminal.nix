{
  lib,
  inputs,
  moduleWithSystem,
  ...
}:
{
  flake-file.inputs = {
    lumen = {
      url = lib.mkDefault "github:jnsahaj/lumen";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
    oyui = {
      url = lib.mkDefault "github:emilien-jegou/oyui";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
  };

  flake.modules.homeManager.options-terminal = moduleWithSystem (
    { system, ... }:
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.terminal = lib.mkOption {
        type = lib.types.submodule {
          options = {
            common.enable = lib.mkEnableOption "terminal-based tools that i need everywhere";
          };
        };
        default = { };
      };

      config = lib.mkIf config.terminal.common.enable {
        nixpkgs.overlays = [
          (_: _: {
            oyui = inputs.oyui.packages.${system}.default;
          })
          inputs.lumen.overlays.default
        ];

        programs = {
          atuin = {
            enable = true;
            enableFishIntegration = true;
            flags = [
              "--disable-up-arrow"
            ];
            settings = {
              style = "full";
              show_help = false;
              show_tabs = false;
            };
          };

          bat = {
            enable = true;
            config.theme = "dankcolors";
          };

          direnv = {
            enable = true;
            nix-direnv.enable = true;
            config.global.hide_env_diff = true;
          };

          eza = {
            enable = true;
            enableFishIntegration = true;
          };

          fd.enable = true;

          fzf = {
            enable = true;
            defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
            changeDirWidget = {
              command = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
              options = [ "--preview 'eza --tree --color=always {} | head -200'" ];
            };
            fileWidget = {
              command = "fd --hidden --strip-cwd-prefix --exclude .git";
              options = [ "--preview 'bat --color=always -n --line-range :500 {}'" ];
            };
            historyWidget.command = "";
          };

          git = {
            enable = true;
            lfs.enable = true;
            settings = {
              init.defaultBranch = "main";
              status = {
                branch = true;
                showStash = true;
                showUntrackedFiles = true;
              };
              column.ui = "auto";
              rerere.enable = true;
              diff.colorMoved = "zebra";
              branch.sort = "-committerdate";
            };
          };

          git-cliff.enable = true;

          gpg.enable = true;

          jujutsu = {
            enable = true;
            settings = {
              ui = {
                default-command = "log";
                conflict-marker-style = "snapshot";
                diff-editor = "oyui";
                diff-instructions = false;
              };
              git = {
                colocate = true;
                ignore-files = [ "lfs" ];
              };
              remotes = {
                origin.auto-track-bookmarks = "glob:*";
                upstream.auto-track-bookmarks = "main";
              };
              merge-tools.oyui = {
                program = "oyui";
                edit-args = [
                  "diff"
                  "$left"
                  "$right"
                ];
              };
            };
          };

          jq.enable = true;

          ripgrep.enable = true;

          ripgrep-all.enable = true;

          zellij.enable = true;

          zoxide = {
            enable = true;
            enableFishIntegration = true;
          };
        };

        services = {
          cliphist.enable = true;
          gpg-agent = {
            enable = true;
            enableFishIntegration = true;
            enableSshSupport = true;
            pinentry.package = pkgs.pinentry-dms;
          };
        };

        xdg.configFile =
          let
            vars = {
              USERNAME = config.home.username;
            };
          in
          {
            "zellij/config.kdl".source = pkgs.replaceVars ./terminal/zellij/config.kdl vars;
          };

        home.packages = builtins.attrValues {
          inherit (pkgs)
            git-annex
            git-filter-repo
            jc
            koji
            libqalculate
            lumen
            numbat
            oyui
            sd
            ueberzugpp
            wl-clipboard
            ;
        };
      };
    }
  );
}
