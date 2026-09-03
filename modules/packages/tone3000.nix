{
  perSystem =
    { pkgs, ... }:
    {
      packages.tone3000 = pkgs.stdenv.mkDerivation rec {
        pname = "tone3000";
        version = "0.0.4";

        src = pkgs.fetchurl {
          url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${version}/TONE3000-v${version}-linux-x64.tar.gz";
          hash = "sha256-lscFVYygBYzgWSDAyU1fhBmSYu8L3SV7kmacBb8Np5k=";
        };

        nativeBuildInputs = builtins.attrValues {
          inherit (pkgs)
            autoPatchelfHook
            ;
        };

        buildInputs =
          builtins.attrValues {
            inherit (pkgs)
              alsa-lib
              freetype
              libX11
              fontconfig
              ;
          }
          ++ [ pkgs.stdenv.cc.cc.lib ];

        appendRunpaths = [
          "${pkgs.webkitgtk_4_1}/lib"
          "${pkgs.gtk3}/lib"
          "${pkgs.curl}/lib"
        ];

        installPhase = ''
          runHook preInstall
          install -Dm755 TONE3000.clap "$out/lib/clap/TONE3000.clap"
          install -Dm644 -t "$out/presets" factory-presets/*.t3kpreset
          runHook postInstall
        '';
      };
    };
}
