{
  self,
  inputs,
  withSystem,
  ...
}:
let
  name = "{{user:k}}";
  description = "{{user:k}}'s description goes here...";
in
{
  # This defines the system aspects of a user profile. Hence, it's part of the "nixos" class.
  # User modules by convention use the "users-" prefix for easy discoverability.
  flake.modules.nixos."users-${name}" = {
    users.users.${name} = {
      isNormalUser = true;
      inherit description;

      extraGroups = [
        "networkmanager"
        "wheel"
        # ...add extra groups to your user here.
      ];
    };

    # This will resolve to NH_FLAKE environment variable.
    common.flake = "/home/${name}/.bootstrap";
    # We don't use common.enable here because it is already defined in the entry point in the
    # host that imports this user module. Separation of concerns!

    # Enable our containers' feature module.
    # Since "containers" is a pre-defined option in nixpkgs, it's a convention to mark the
    # abstracted modules using the prime (') symbol.
    containers'.enable = true;

    # Enable our flatpak and appimage feature modules.
    packaging = {
      flatpak.enable = true;
      appimage.enable = true;
    };

    # You can find the definition of these feature modules and add more in modules/features.
    # You can enable them later here or where it makes more sense.
    # Of note, only modules of "nixos" class can be used in modules of "nixos" class.
  };

  # Home-manager configurations are managed as a "user per host" relation.
  # This uses the user@host convention which makes it easy to reuse users and host across
  # different variations. For example: user@host2, user2@host, user33@host4, etc.
  flake.homeConfigurations."${name}@{{host:k}}" = withSystem "{{system}}" (
    { pkgs, ... }:
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        # This is where you import modules of "homeManager" class to be used in this
        # particular relation.
        self.modules.homeManager.options-browsers
        self.modules.homeManager.options-editors
        self.modules.homeManager.options-packaging
        # ...
        self.modules.homeManager."users-${name}"
        # Note the "options-" prefix for feature modules and "users-" prefix for user
        # modules convention (again)!
        {
          home.stateVersion = "{{stateVersion}}";

          # Enable unfree software for home-manager specfically if you want to do so.
          # nixpkgs.config.allowUnfree = true;
        }
      ];
    }
  );

  # This defines the home aspects of a user profile that you want to manage using home-manager.
  # Uses the same "users-" prefix convention but is part of the "homeManager" class.
  flake.modules.homeManager."users-${name}" =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        # ...you can put your overlays here if you want to.
        # Or, use the global/unified overlays convention if you prefer to do so.
        # Check modules/overlays for mode information.
      ];

      home = {
        inherit name;
        homeDirectory = "/home/${name}";
        # It's 2026+, please let go of the poor "with"!
        packages = builtins.attrValues {
          inherit (pkgs)
            # ...put the packages you want here.
            # e.g. bootstrap's generate itself that is injected via the global/unified overlays!
            generate
            ;
        };
      };

      # Remember the options-browsers module we added? Time to use it!
      browsers.helium.enable = true;

      # Let's pull in zed-editor too!
      editors.zed-editor.enable = true;

      # Let's enable some essential flatpak apps!
      packaging.flatpak.enableEssentials = true;

      # ...and all you custom modules of "homeManager" class goes here.
      # Check modules/features for more information. It's trivial to define feature modules of
      # different class in one file!

      # You can also use the normal home-manager options!
      programs = {
        # Time to enable the best terminal emulator!
        kitty.enable = true;

        # Let home-manager manage itself.
        home-manager.enable = true;

        # ...and your usual program.* stuff goes here.
      };

      # You can use all home-manager options here, which includes services!
      services.easyeffects.enable = true;
    };
}
