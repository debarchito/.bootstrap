let
  name = "{{host:k}}";
in
{
  # flake-parts again merges this for us automatically!
  # This allows us to separate the hardware bits and make sense of them easily.
  flake.modules.nixos."hosts-${name}" = {
    # NOTE: Raw files are treated as external dependencies thus, are a special case for relative imports.
    # This is the only place where we break the dendritic tradition and for good reasons. It makes it a
    # lot easier to just consume the hardware-configuration as is, without requiring us to convert it into
    # a flake-parts module. It reduces friction by being pragmatic about it.
    imports = [
      # WARNING: YOU MUST CREATE THIS PATH YOURSELF AND COPY YOUR /etc/nixos/hardware-configuration.nix TO
      # THIS LOCATION!
      ./_raw/hardware-configuration.nix
    ];

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
      # ...and other boot options you care about goes here.
    };

    # This is always useful if your swap is backed by a block device.
    zramSwap.enable = true;
  };
}
