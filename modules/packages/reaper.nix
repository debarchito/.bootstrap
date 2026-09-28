{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = rec {
        value = "7.81";
        major = "${builtins.head (lib.splitString "." value)}.x";
        slug = lib.replaceString "." "" value;
      };
      sources = {
        "x86_64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_x86_64.tar.xz";
          hash = "sha256-1WVIaKD08xowslG1T//DLKmsV42ZgV6HwAkD1Ln3iLk=";
        };
        "aarch64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_aarch64.tar.xz";
          hash = "sha256-Bb/IVY1uundgUBytGvl9MtUZ5l7TWCbaw0MUIwYvBb4=";
        };
      };
    in
    {
      packages = lib.optionalAttrs (sources ? ${system}) {
        reaper = pkgs.reaper.overrideAttrs (_: {
          version = version.value;
          src = pkgs.fetchurl {
            inherit (sources.${system}) url hash;
          };
        });
      };
    };
}
