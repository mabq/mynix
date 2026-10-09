{ lib, config, ... }:
{
  options = {
    mynix.starship.configName = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Starship configuration name";
    };
  };

  config =
    let
      inherit (config.mynix) user;
    in
    {
      flake.nixosModules.starship = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
          starship # Customizable prompt for any shell
        ];

        hjem.users.${user}.files = {
          ".config/starship.toml".source = ./configs/${config.mynix.starship.configName}.toml;
        };
      };
    };
}

#  Starship must be initialized by a shell config file
