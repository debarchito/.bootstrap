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
                meow
                vertico
                orderless
                consult
                corfu
                cape
                avy
                eat
                envrc
                clojure-ts-mode
                fish-mode
                haskell-mode
                kdl-mode
                nix-ts-mode
                ocaml-ts-mode
                ;
            };
        };

        services.emacs = {
          enable = true;
          client.enable = true;
        };

        xdg.configFile."emacs/init.el".source = ./emacs/init.el;
      };
    };
}
