{
  flake.modules.homeManager.options-browsers =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options.browsers = lib.mkOption {
        type = lib.types.submodule {
          options = {
            helium.enable = lib.mkEnableOption "enable helium browser";
          };
        };
        default = { };
      };

      # This is a good example of when options can be rather redundant but it make the
      # interface uniform.
      config = lib.mkIf config.browsers.helium.enable {
        home.packages = builtins.attrValues {
          inherit (pkgs)
            helium
            ;
        };
      };
    };
}
