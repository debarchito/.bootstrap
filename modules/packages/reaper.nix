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
        value = "7.85";
        major = "${builtins.head (lib.splitString "." value)}.x";
        slug = lib.replaceString "." "" value;
      };
      sources = {
        "x86_64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_x86_64.tar.xz";
          hash = "sha256-uWLEClFTXS+vl5b1YnD54zHJ1CS1dBRyJ317/WxIk6w=";
        };
        "aarch64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_aarch64.tar.xz";
          hash = "sha256-g/lEeGSoUUBDBZ5xNpZGpc9bul2p06o2PvMLpkQ8+PU=";
        };
      };
    in
    {
      packages = lib.optionalAttrs (sources ? ${system}) {
        reaper = pkgs.reaper.overrideAttrs (oldAttrs: {
          version = version.value;
          src = pkgs.fetchurl {
            inherit (sources.${system}) url hash;
          };
          patchelfFlags = (oldAttrs.patchelfFlags or [ ]) ++ [
            "--page-size"
            "2097152"
          ];
        });
      };
    };
}
