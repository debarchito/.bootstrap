{
  flake.modules.homeManager.options-terminal = { lib, config, ... }: {
    config = lib.mkIf config.terminal.common.enable {
      programs.starship = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          format = lib.concatStrings [
            "$username"
            "$hostname"
            "$os"
            "$directory"
            "$pijul_channel"
            "$git_branch"
            "$git_state"
            "$git_status"
            "$cmd_duration"
            "$nix_shell"
            "$python"
            "$line_break"
            "$character"
          ];
          hostname.ssh_symbol = " ";
          os = {
            disabled = false;
            symbols = {
              Arch = "╭ 󰣇 ";
              Debian = "╭  ";
              Fedora = "╭  ";
              NixOS = "╭ 󱄅 ";
            };
            style = "bold cyan";
          };
          directory.style = "cyan";
          character = {
            success_symbol = "[╰─❯](cyan)";
            error_symbol = "[╰─❯](red)";
            vimcmd_symbol = "[╰ ](green)";
            vimcmd_visual_symbol = "[╰ 󰼢](#ff5c5c)";
            vimcmd_replace_symbol = "[╰ 󰛔 *](#ff5c5c)";
            vimcmd_replace_one_symbol = "[╰ 󰛔 1](#ff5c5c)";
          };
          pijul_channel = {
            disabled = false;
            format = "[󰬗 $channel]($style) ";
            style = "bright-black";
          };
          git_branch = {
            format = "[ $branch]($style)";
            style = "bright-black";
          };
          git_status = {
            format = "[[($conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead$behind$stashed$diverged)]($style)";
            style = "orange";
            conflicted = " ⚠";
            untracked = " ";
            modified = " 󰏫";
            staged = " ●";
            renamed = " »";
            deleted = " ";
            stashed = " ";
            ahead = " ⇡";
            behind = " ⇣";
            diverged = " ⇕";
          };
          git_state = {
            format = "\([$state( $progress_current/$progress_total)]($style)\) ";
            style = "bright-black";
          };
          cmd_duration = {
            format = "[$duration]($style) ";
            style = "bold cyan";
          };
          nix_shell = {
            format = "@ [󱄅 $name](bold blue) ";
          };
          python = {
            format = "@ [ $virtualenv](bold cyan) ";
          };
        };
      };
    };
  };
}
