{ inputs, self, ... }:
let
  name = "{{host:k}}";
in
{
  # This is where the modules of "nixos" class are imported!
  flake.nixosConfigurations.${name} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.modules.nixos.options-common
      self.modules.nixos.options-containers'
      self.modules.nixos.options-packaging
      # ...add more modules of "nixos" class.
      # Import the host module!
      self.modules.nixos."hosts-${name}"
      # Import your users!
      self.modules.nixos."users-{{user:k}}"
    ];
  };

  # Just like user modules, host modules have the "hosts-" prefix convention!
  flake.modules.nixos."hosts-${name}" = {
    system.stateVersion = "{{stateVersion}}";

    # Enable unfree software if you will!
    # nixpkgs.config.allowUnfree = true;

    # ...add you locale stuff here. Basically everything that goes in a "configuration.nix"
    # traditionally.

    # Remember the common modules we imported just now? Let's use them!
    common = {
      enable = true;
      desktop.enable = true;
    };
    # We'll keep common.flake for the user module to define. Separation of concerns!

    # We're feeling a bit exploratory today.
    services.guix = {
      enable = true;
      gc.enable = true;
    };

    # All your nixos options can reside here as they usually would.
  };
}
