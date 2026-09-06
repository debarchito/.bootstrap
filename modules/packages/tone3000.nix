{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      version = "0.0.5";
      sources = {
        "x86_64-linux" = {
          url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${version}/TONE3000-v${version}-linux-x64.tar.gz";
          hash = "sha256-Hqe0PrLZrPXjsLsdXS+yqWzDM+uYkWBlJ0jncb3hAB4=";
        };
        "aarch64-linux" = {
          url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${version}/TONE3000-v${version}-linux-aarch64.tar.gz";
          hash = "sha256-pR1uRQk5RY3NlWvpKzkk1NPkuNrfBcv6GWJx/1HuVew=";
        };
      };
    in
    {
      packages = lib.optionalAttrs (sources ? ${system}) {
        tone3000 = pkgs.stdenv.mkDerivation {
          pname = "tone3000";
          inherit version;

          src = pkgs.fetchurl {
            inherit (sources.${system}) url hash;
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
    };
}
