{
  # See how the module name "options-editors" is still the same?
  # flake-parts handles the merging for us!
  flake.modules.homeManager.options-editors =
    { lib, config, ... }:
    {
      # This is the config body we were looking for!
      config = lib.mkIf config.editors.zed-editor.enable {
        programs.zed-editor = {
          enable = true;
          userSettings = {
            ui_font_size = 16;
            buffer_font_size = 16;
            buffer_font_family = "Maple Mono NF";
            relative_line_numbers = "enabled";
            title_bar = {
              show_sign_in = false;
              show_user_picture = false;
            };
            window_decorations = "server";
            terminal.font_family = "Maple Mono NF";
            telemetry = {
              metrics = false;
              diagnostics = false;
            };
            disable_ai = true;
            # Zed has the best helix emulation mode!
            helix_mode = true;
            load_direnv = "shell_hook";
          };
        };
      };
    };
}
