{ lib, config, ... }:
let
  inherit (config.mynix) user;
in
{
  options = {

    mynix.git.configName = lib.mkOption {
      type = lib.types.str;
      default = user;
      description = "Git configuration name";
    };

    mynix.lazygit.configName = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Lazygit configuration name";
    };

  };

  config = {

    flake.nixosModules.git = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        git # Distributed version control system
        gh # CLI GitHub tool (authenticate from the terminal)
        lazygit # Simple terminal UI for git commands
        delta # Syntax-highlighting pager for git
      ];

      hjem.users.${user}.files = {
        ".config/git/config".source = ./configs/git/${config.mynix.git.configName};
        ".config/lazygit/config.yml".source = ./configs/lazygit/${config.mynix.lazygit.configName}.yml;
      };
    };

  };
}
