{
  flake.nixosModules.git =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user gitConfig lazygitConfig;
    in
    {
      options = {

        mynix.gitConfig = lib.mkOption {
          type = lib.types.str;
          default = user;
          description = "Git configuration name";
        };

        mynix.lazygitConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Lazygit configuration name";
        };

      };

      config = {

        environment.systemPackages = with pkgs; [
          git # Distributed version control system
          gh # CLI GitHub tool (authenticate from the terminal)
          lazygit # Simple terminal UI for git commands
          delta # Syntax-highlighting pager for git
        ];

        hjem.users.${user}.files = {
          ".config/git/config".source = ./configs/git/${gitConfig};
          ".config/lazygit/config.yml".source = ./configs/lazygit/${lazygitConfig}.yml;
        };

      };

    };
}
