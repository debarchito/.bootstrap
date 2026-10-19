{ inputs, lib, ... }:
{
  flake-file.inputs = {
    niri-source = {
      url = lib.mkDefault "github:barrulus/biri";
      flake = false;
    };
    niri = {
      url = lib.mkDefault "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
      inputs.niri-unstable.follows = lib.mkDefault "niri-source";
    };
    xwayland-satellite = {
      url = lib.mkDefault "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = lib.mkDefault "nixpkgs";
    };
  };

  flake.modules.nixos.options-desktop =
    { config, pkgs, ... }:
    {
      imports = [
        inputs.niri.nixosModules.niri
      ];

      config = lib.mkIf config.desktop.niri.enable {
        nixpkgs.overlays = [
          inputs.niri.overlays.niri
          inputs.xwayland-satellite.overlays.default
        ];

        programs = {
          niri = {
            enable = true;
            package = pkgs.niri-unstable;
          };
          seahorse.enable = true;
        };

        services = {
          gvfs = {
            enable = true;
            package = pkgs.gnome.gvfs;
          };
          gnome.gnome-keyring.enable = true;
        };

        security.pam.services.login.enableGnomeKeyring = true;

        environment.systemPackages = builtins.attrValues {
          inherit (pkgs) nautilus xwayland-satellite;
        };
      };
    };

  flake.modules.homeManager.options-desktop =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.niri.homeModules.config
      ];

      config = lib.mkIf config.desktop.niri.enable {
        nixpkgs.overlays = [
          inputs.niri.overlays.niri
          inputs.quickshell.overlays.default
        ];

        programs.niri = {
          package = pkgs.niri-unstable;
          # NOTE: Inlining is fine since the dank-material-shell is the only niri config i've rn
          config = builtins.readFile ./dank-material-shell/niri/config.kdl;
        };

        xdg.configFile =
          let
            vars.USERNAME = config.home.username;
          in
          {
            # TODO: Make matugen independent of dank-material-shell at some point
            "matugen".source = ./dank-material-shell/matugen;
            "qt5ct/qt5ct.conf".source = pkgs.replaceVars ./qt5ct/qt5ct.conf vars;
            "qt6ct/qt6ct.conf".source = pkgs.replaceVars ./qt6ct/qt6ct.conf vars;
          };

        fonts.fontconfig = {
          enable = true;
          defaultFonts = {
            serif = [
              "Lora"
              "Noto Serif CJK JP"
              "Noto Serif CJK SC"
              "Noto Serif CJK TC"
              "Noto Serif CJK HK"
              "Noto Serif CJK KR"
            ];
            sansSerif = [
              "Poppins"
              "Noto Sans CJK JP"
              "Noto Sans CJK SC"
              "Noto Sans CJK TC"
              "Noto Sans CJK HK"
              "Noto Sans CJK KR"
            ];
            monospace = [
              "Maple Mono NF"
              "Noto Sans Mono CJK JP"
              "Noto Sans Mono CJK SC"
              "Noto Sans Mono CJK TC"
              "Noto Sans Mono CJK HK"
              "Noto Sans Mono CJK KR"
            ];
          };
        };

        gtk = {
          enable = true;
          font = {
            name = "Poppins";
            size = 10;
          };
          gtk3.theme = {
            name = "adw-gtk3";
            package = pkgs.adw-gtk3;
          };
          gtk4.theme = config.gtk.theme;
        };

        qt = {
          enable = true;
          platformTheme = {
            name = "qtct";
            package = pkgs.qt6ct;
          };
        };

        home = {
          packages = builtins.attrValues {
            inherit (pkgs)
              corefonts
              lora
              noto-fonts-cjk-sans
              noto-fonts-cjk-serif
              papirus-folders
              poppins
              pywalfox-native
              qt6ct
              vista-fonts
              wlr-which-key
              ;
            inherit (pkgs.maple-mono) NF;
            inherit (pkgs.kdePackages) breeze;
            inherit (pkgs.libsForQt5) qt5ct;
          };
          activation = {
            papirus-install =
              lib.hm.dag.entryAfter [ "writeBoundary" ]
                # bash
                ''
                  OUTPUT_DIR="$HOME/.local/share/icons"
                  REPO_URL='https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git'
                  REPO_REV='bf539287ef5dc18529424a02cccee76175920a6f'
                  GIT='${lib.getExe pkgs.git}'

                  if [ -d "$OUTPUT_DIR/Papirus" ]; then
                    echo "[?] Papirus icon theme already exists. Skipping."
                  else
                    echo '[-*-] Fetching and installing Papirus icon theme...'

                    mkdir -p "$OUTPUT_DIR"

                    TMP_DIR=$(mktemp -d)
                    trap 'rm -rf "$TMP_DIR"' EXIT

                    "$GIT" -c advice.detachedHead=false clone \
                      --revision="$REPO_REV" \
                      --depth=1 \
                      --filter=blob:none \
                      --sparse "$REPO_URL" "$TMP_DIR"
                    "$GIT" -C "$TMP_DIR" sparse-checkout set Papirus

                    cp -r "$TMP_DIR/Papirus" "$OUTPUT_DIR/Papirus"

                    echo "[+] Successfully installed Papirus icon theme."
                  fi
                '';
            bibata-material-cursors =
              lib.hm.dag.entryAfter [ "writeBoundary" ]
                # bash
                ''
                  OUTPUT_DIR="$HOME/.local/share/icons"
                  DARK_THEME='https://github.com/SakibShahariar/material-bibata-cursor/releases/download/v1.5.0/bibata-material-dark-v1.5.0.tar.gz'
                  LIGHT_THEME='https://github.com/SakibShahariar/material-bibata-cursor/releases/download/v1.5.0/bibata-material-light-v1.5.0.tar.gz'
                  CURL="${lib.getExe pkgs.curl}"
                  TAR="${lib.getExe pkgs.gnutar}"

                  export PATH="${
                    lib.makeBinPath [
                      pkgs.curl
                      pkgs.gnutar
                      pkgs.gzip
                    ]
                  }:$PATH"

                  if [ -n "$(find "$OUTPUT_DIR" -maxdepth 1 -type d -name "Bibata-Material-*" 2>/dev/null)" ]; then
                    echo "[?] bibata-material-cursors are already installed. Skipping."
                  else
                    echo '[-*-] Fetching and installing bibata-material-cursors...'
                    
                    mkdir -p "$OUTPUT_DIR"

                    TMP_DIR=$(mktemp -d)
                    trap 'rm -rf "$TMP_DIR"' EXIT

                    "$CURL" -sSL "$DARK_THEME" -o "$TMP_DIR/DARK_THEME.tar.gz"
                    "$TAR" -xzf "$TMP_DIR/DARK_THEME.tar.gz" -C "$TMP_DIR"
                    
                    "$CURL" -sSL "$LIGHT_THEME" -o "$TMP_DIR/LIGHT_THEME.tar.gz"
                    "$TAR" -xzf "$TMP_DIR/LIGHT_THEME.tar.gz" -C "$TMP_DIR"
                    
                    mv "$TMP_DIR"/bibata-material-dark-v1.5.0/* "$OUTPUT_DIR/"
                    mv "$TMP_DIR"/bibata-material-light-v1.5.0/* "$OUTPUT_DIR/"

                    echo "[+] Successfully installed bibata-material-cursors."
                  fi
                '';
          };
        };
      };
    };
}
