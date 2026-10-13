{
  flake.nixosModules.cliamp =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user;
    in
    {

      options = {
        mynix.cliampConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected cliamp configuration";
        };
      };

      config = {
        environment.systemPackages = [
          pkgs.cliamp # Terminal Winamp - a retro terminal music player inspired by Winamp 2.x
        ];

        hjem.users.${user}.files = {
          ".config/cliamp/config.toml".source = ./configs/${user}.toml;
        };
      };
    };

}
