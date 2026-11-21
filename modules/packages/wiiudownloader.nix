{ inputs, ... }:
{
  flake-file.inputs.wiiudownloader = {
    url = "github:Xpl0itU/WiiUDownloader";
    flake = false;
  };

  perSystem =
    { pkgs, ... }:
    {
      packages =
        let
          db =
            pkgs.runCommand "db.go"
              {
                nativeBuildInputs = [
                  pkgs.curl
                  pkgs.cacert
                ];
                outputHashAlgo = "sha256";
                outputHashMode = "flat";
                outputHash = "sha256-yR8fQOr5K9vM9PkGKX1Umikd6jfwNvslmgQyb2CrW7I=";
              }
              ''
                curl --compressed -fsSL -A "NUSspliBuilder/2.2" "https://napi.v10lator.de/db?t=go" -o "$out"
              '';
        in
        {
          wiiudownloader = pkgs.buildGoModule {
            pname = "WiiUDownloader";
            version = "main";

            src = inputs.wiiudownloader.outPath;
            modRoot = "cmd/WiiUDownloader";
            vendorHash = "sha256-MwO+CgkqrW87cIEJe87mnfd52hTzpQxGc2dzJ4VoiGo=";

            nativeBuildInputs = with pkgs; [
              pkg-config
              wrapGAppsHook4
            ];

            buildInputs = with pkgs; [
              gobject-introspection
              gtk4
              libadwaita
            ];

            postPatch = ''
              cp --no-preserve=mode ${db} db.go

              if grep -q 'var titleEntry =' db.go; then
                if grep -q 'type TitleEntry struct' db.go; then
                  sed -i '/type TitleEntry struct/,/}/d' db.go
                fi
                sed -i 's/var titleEntry =/func init() { TitleDatabase =/' db.go
                echo '}' >> db.go
              fi
            '';

            subPackages = [ "." ];

            postInstall = ''
              install -m 444 -D ../../packaging/appimage/WiiUDownloader.desktop $out/share/applications/WiiUDownloader.desktop
              install -m 444 -D ../../data/WiiUDownloader.png $out/share/icons/hicolor/512x512/apps/WiiUDownloader.png

              substituteInPlace $out/share/applications/WiiUDownloader.desktop \
                --replace-fail 'Exec=wiiudownloader' "Exec=$out/bin/WiiUDownloader"
            '';
          };
        };
    };
}
