{
  # See how modules of both "nixos" and "homeManager" class stay inside
  # a single features directory? No special boundary needed outside the
  # classes itself!
  flake.modules.homeManager.options-editors =
    { lib, ... }:
    {
      options.editors = lib.mkOption {
        type = lib.types.submodule {
          options = {
            zed-editor.enable = lib.mkEnableOption "enable zed editor";
          };
        };
        default = { };
      };

      # This file has no config block! This is another convention to make modules
      # more modular. The option definition of each module for e.g. "options-editors"
      # stay in this file but the body (config) go in a directory of the same name.
      # Thus, the zed-editor's config is inside editors/zed-editor.nix. Very similar to
      # Rust modules!
    };
}
