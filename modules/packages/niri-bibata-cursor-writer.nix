{
  perSystem =
    { pkgs, ... }:
    {
      packages.niri-bibata-cursor-writer =
        pkgs.writers.writeFishBin "niri-bibata-cursor-writer" { }
          # fish
          ''
            if test (count $argv) -lt 2
                echo "Error: Missing arguments."
                echo "Usage: niri-bibata-cursor-writer <theme-name> <mode>"
                exit 1
            end

            set base_name $argv[1]
            set mode $argv[2]
            set config_dir "$HOME/.config/niri/matugen"

            if test "$mode" = "light"
                set theme_name "Bibata-Material-$base_name-Light"
            else
                set theme_name "Bibata-Material-$base_name"
            end

            mkdir -p "$config_dir"

            echo "cursor {
                xcursor-theme \"$theme_name\"
            }" > "$config_dir/cursor-theme.kdl"

            echo "Updated cursor theme to '$theme_name' in $config_dir/cursor-theme.kdl"
          '';
    };
}
