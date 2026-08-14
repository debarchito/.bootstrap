{
  perSystem =
    { pkgs, ... }:
    {
      packages.neuralrack = pkgs.stdenv.mkDerivation rec {
        pname = "neuralrack";
        version = "0.4.1";

        src = pkgs.fetchgit {
          url = "https://github.com/brummer10/NeuralRack.git";
          tag = "v${version}";
          hash = "sha256-60b18rAj4Za0H1lzPzvRYQdLFMYCBkKGMmSYJGBOaIQ=";
          fetchSubmodules = true;
        };

        nativeBuildInputs = builtins.attrValues {
          inherit (pkgs)
            pkg-config
            gnumake
            ;
        };

        buildInputs = builtins.attrValues {
          inherit (pkgs)
            libsndfile
            cairo
            libX11
            ;
        };

        buildPhase = ''
          runHook preBuild
          make clap AR=gcc-ar RANLIB=gcc-ranlib
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -Dm755 NeuralRack/NeuralRack.clap "$out/lib/clap/NeuralRack.clap"
          runHook postInstall
        '';
      };
    };
}
