{ lib, inputs, ... }:
{
  flake-file.inputs.emacs-overlay = {
    url = lib.mkDefault "github:nix-community/emacs-overlay";
    inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
  };

  flake.modules.homeManager.options-editors =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.editors.emacs.enable {
        nixpkgs.overlays = [
          (import inputs.emacs-overlay)
        ];

        programs.emacs = {
          enable = true;
          package = pkgs.emacs-git-pgtk;
          extraPackages =
            epkgs:
            builtins.attrValues {
              inherit (epkgs.treesit-grammars)
                with-all-grammars
                ;
            }
            ++ builtins.attrValues {
              inherit (epkgs)
                astro-ts-mode
                avy
                cape
                consult
                corfu
                eat
                envrc
                fish-mode
                haskell-mode
                indent-bars
                kdl-mode
                meow
                nix-ts-mode
                nu-ts-mode
                ocaml-ts-mode
                orderless
                proof-general
                scala-ts-mode
                svelte-mode
                vertico
                ;
            };
        };

        services.emacs = {
          enable = true;
          client.enable = true;
        };

        "xdg".configFile = {
          "emacs/init.el".source = ./emacs/init.el;
          "emacs/early-init.el".source = ./emacs/early-init.el;
        };
      };
    };
}
