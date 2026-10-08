{ lib, config, ... }:
{
  options = {
    mynix.tmux.configName = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Tmux configuration name";
    };
  };

  config =
    let
      inherit (config.mynix) user;
    in
    {
      flake.nixosModules.tmux = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
          tmux # Terminal multiplexer
          fd # Simple, fast and user-friendly alternative to find (!tmux-sessionizer)
          fzf # Command-line fuzzy finder (!tmux-sessionizer)
        ];

        hjem.users.${user}.files = {
          ".config/tmux/tmux.conf".source = ./configs/${config.mynix.tmux.configName}.conf;
          ".local/bin/tmux-sessionizer" = {
            source = ./scripts/tmux-sessionizer;
            executable = true;
          };
        };
      };
    };
}

/*
  Related configurations:

    The bare module adds localBinInPath (~/.local/bin).

    Shortcuts to trigger the script are set in the shell config files (zsh) and in
    neovim config files.
*/
