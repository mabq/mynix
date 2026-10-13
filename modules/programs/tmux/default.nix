{
  flake.nixosModules.tmux =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user tmuxConfig;
    in
    {

      options = {
        mynix.tmuxConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected tmux configuration";
        };
      };

      config = {
        environment.systemPackages = with pkgs; [
          tmux # Terminal multiplexer
          fd # Simple, fast and user-friendly alternative to find (!tmux-sessionizer)
          fzf # Command-line fuzzy finder (!tmux-sessionizer)
        ];

        hjem.users.${user}.files = {
          ".config/tmux/tmux.conf".source = ./configs/${tmuxConfig}.conf;

          # The bare module adds `~/.local/bin` to PATH.
          # Shortcuts to trigger the script are set in the shell config files
          # (zsh) and in neovim config files.
          ".local/bin/tmux-sessionizer" = {
            source = ./scripts/tmux-sessionizer;
            executable = true;
          };
        };
      };

    };
}
