{
  perSystem =
    { pkgs, ... }:
    {
      packages.calculate-hash-section =
        pkgs.writers.writeFishBin "waydroid-choose-gpu" { }
          # fish
          ''
            if test (count $argv) -lt 2
                echo "Usage: ./calculate-hash-section <package> <version>" >&2
                exit 1
            end

            set package_name $argv[1]
            set package_version $argv[2]

            switch $package_name
                case helium
                    set architectures x86_64-linux aarch64-linux
                    set templates \
                        'https://github.com/imputnet/helium-linux/releases/download/$\{version}/helium-$\{version}-x86_64.AppImage' \
                        'https://github.com/imputnet/helium-linux/releases/download/$\{version}/helium-$\{version}-arm64.AppImage'

                case tone3000
                    set architectures x86_64-linux aarch64-linux
                    set templates \
                        'https://github.com/tone-3000/tone3000-plugin/releases/download/v$\{version}/TONE3000-v$\{version}-linux-x64.tar.gz' \
                        'https://github.com/tone-3000/tone3000-plugin/releases/download/v$\{version}/TONE3000-v$\{version}-linux-aarch64.tar.gz'

                case wiiudownloader
                    set architectures x86_64-linux aarch64-linux
                    set templates \
                        'https://github.com/Xpl0itU/WiiUDownloader/releases/download/v$\{version}/WiiUDownloader-Linux-x86_64.AppImage' \
                        'https://github.com/Xpl0itU/WiiUDownloader/releases/download/v$\{version}/WiiUDownloader-Linux-aarch64.AppImage'

                case '*'
                    echo "Error: Unknown package_name '$package_name'" >&2
                    exit 1
            end

            function get_sri_hash
                set url $argv[1]

                set fetch_output (nix-prefetch-url --print-path $url)
                if test $status -ne 0
                    echo "[x] Failed to download: $url" >&2
                    return 1
                end

                set raw_hash $fetch_output[1]

                nix hash convert --to sri --hash-algo sha256 $raw_hash | string trim
            end

            echo "version = \"$package_version\";"
            echo "sources = {"

            for i in (seq (count $architectures))
                set arch $architectures[$i]
                set template $templates[$i]

                set download_url (string replace --all '$\{version}' $package_version $template)

                set hash (get_sri_hash $download_url)
                if test -z "$hash"
                    exit 1
                end

                echo "  \"$arch\" = {"
                echo "    url = \"$template\";"
                echo "    hash = \"$hash\";"
                echo "  };"
            end

            echo "};"
          '';
    };
}
