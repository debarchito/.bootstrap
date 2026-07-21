{
  flake.modules.homeManager.options-editors =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.editors.emacs.enable {
        programs.emacs = {
          enable = true;
          package = pkgs.emacs-pgtk;
          extraPackages = epkgs: [
            epkgs.meow
            epkgs.treesit-grammars.with-all-grammars
            epkgs.clojure-ts-mode
            epkgs.fish-mode
            epkgs.haskell-mode
            epkgs.kdl-mode
            epkgs.nix-ts-mode
            epkgs.ocaml-ts-mode
          ];
        };

        services.emacs = {
          enable = true;
          client.enable = true;
        };

        xdg.configFile."emacs/init.el".source = ./emacs/init.el;
      };
    };
}
