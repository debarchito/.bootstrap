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
        value = "7.86";
        major = "${builtins.head (lib.splitString "." value)}.x";
        slug = lib.replaceString "." "" value;
      };
      sources = {
        "x86_64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_x86_64.tar.xz";
          hash = "sha256-wvnYYWvR3GF1mTuCRR4cbjUsZ2Hnrm1yQAo/PfsDvts=";
        };
        "aarch64-linux" = {
          url = "https://www.reaper.fm/files/${version.major}/reaper${version.slug}_linux_aarch64.tar.xz";
          hash = "sha256-WzO1HbXawfdBcrRJ63Zbl3jfTb3LFk2TCpR9jLNHZlY=";
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
