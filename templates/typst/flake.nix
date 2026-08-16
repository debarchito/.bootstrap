{
  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      flake-parts,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, lib, ... }:
        let
          sioyek = pkgs.sioyek.overrideAttrs (old: {
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
            postInstall = (old.postInstall or "") + ''
              wrapProgram $out/bin/sioyek --set QT_QPA_PLATFORM xcb
            '';
          });

          pdf = pkgs.stdenvNoCC.mkDerivation {
            pname = "{{name:k}}";
            version = "0.1.0";

            src = lib.cleanSource ./.;
            nativeBuildInputs = [ pkgs.typst ];

            buildPhase = ''
              runHook preBuild
              typst compile src/{{name:TS}}.typ output.pdf
              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p $out
              cp output.pdf $out/{{name:TS}}.pdf
              runHook postInstall
            '';
          };
        in
        {
          packages = rec {
            default = pdf;
            {{name:k}} = default;
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              typstyle.enable = true;
            };
          };

          devShells.default = pkgs.mkShellNoCC {
            name = "{{name:k}}-dev";

            packages =
              builtins.attrValues {
                inherit (pkgs)
                  just
                  tinymist
                  typst
                  typstyle
                  ;
              }
              ++ [ sioyek ];
          };
        };
    };
}
