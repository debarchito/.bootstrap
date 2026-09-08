{ lib, inputs, ... }:
{
  flake-file.inputs.emacs-overlay = {
    url = lib.mkDefault "github:nix-community/emacs-overlay/89fc44c828d3400485349580c83143a13734bdca";
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
                avy
                cape
                clojure-ts-mode
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
                ocaml-ts-mode
                orderless
                vertico
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
