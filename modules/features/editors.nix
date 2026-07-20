{
  flake.modules.homeManager.options-editors =
    { lib, ... }:
    {
      options.editors = lib.mkOption {
        type = lib.types.submodule {
          options = {
            emacs.enable = lib.mkEnableOption "enable emacs";
            zed-editor.enable = lib.mkEnableOption "enable zed editor";
          };
        };
        default = { };
      };
    };
}
