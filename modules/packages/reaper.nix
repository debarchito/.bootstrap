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
        value = "7.84";
        major = "${builtins.head (lib.splitString "." value)}.x";
        slug = lib.replaceString "." "" value;
      };
      sources = {
        "x86_64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_x86_64.tar.xz";
          hash = "sha256-2Hs5hivsaoK7tTBzGuH6NrukvJlU/3JRihh0IO7Z7H0=";
        };
        "aarch64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_aarch64.tar.xz";
          hash = "sha256-Ot54aJvsKTFcGRTjo1S0UPMbf6Ru8By0ON9tMXGnqSM=";
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
