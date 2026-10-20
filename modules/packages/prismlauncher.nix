{
  perSystem =
    { pkgs, ... }:
    let
      prismlauncher-unwrapped = pkgs.prismlauncher-unwrapped.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ./_patches/prismlauncher-unwrapped.patch
        ];
      });
    in
    {
      packages = {
        inherit prismlauncher-unwrapped;
        prismlauncher = pkgs.prismlauncher.override {
          inherit prismlauncher-unwrapped;
          jdks = [ pkgs.jdk25 ];
        };
      };
    };
}
