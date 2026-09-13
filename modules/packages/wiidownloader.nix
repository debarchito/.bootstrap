{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = "2.105";
      sources = {
        "x86_64-linux" = {
          url = "https://github.com/Xpl0itU/WiiUDownloader/releases/download/v${version}/WiiUDownloader-Linux-x86_64.AppImage";
          hash = "sha256-Xptv7iBlf9Hj1wNKnxGe53k0ubZhPK9qPMiwEt+8WKI=";
        };
        "aarch64-linux" = {
          url = "https://github.com/Xpl0itU/WiiUDownloader/releases/download/v${version}/WiiUDownloader-Linux-aarch64.AppImage";
          hash = "sha256-JuNzpVgvXEqtRjQhSQVJWPrI8tWVV2Pm7v4xf9UMgkU=";
        };
      };
    in
    {
      packages = lib.optionalAttrs (sources ? ${system}) {
        wiiudownloader =
          let
            src = pkgs.fetchurl {
              inherit (sources.${system}) url hash;
            };
            appimageContents = pkgs.appimageTools.extract {
              pname = "WiiUDownloader";
              inherit version src;
            };
          in
          pkgs.appimageTools.wrapType2 {
            pname = "WiiUDownloader";
            inherit version src;
            extraInstallCommands =
              # bash
              ''
                export INSTALL='${lib.getExe' pkgs.coreutils "install"}'

                "$INSTALL" -m 444 -D ${appimageContents}/WiiUDownloader.desktop $out/share/applications/WiiUDownloader.desktop
                "$INSTALL" -m 444 -D ${appimageContents}/WiiUDownloader.png $out/share/icons/hicolor/512x512/apps/WiiUDownloader.png

                substituteInPlace $out/share/applications/WiiUDownloader.desktop \
                  --replace 'Exec=AppRun' 'Exec=WiiUDownloader'
              '';
          };
      };
    };
}
