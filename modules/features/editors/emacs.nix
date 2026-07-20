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
            epkgs.nix-ts-mode
          ];
        };

        services.emacs = {
          enable = true;
          client.enable = true;
        };
      };
    };
}
