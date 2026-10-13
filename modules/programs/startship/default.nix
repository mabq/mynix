{
  flake.nixosModules.starship =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user starshipConfig;
    in
    {

      options = {
        mynix.starshipConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected starship configuration";
        };
      };

      config = {
        environment.systemPackages = with pkgs; [
          starship # Customizable prompt for any shell
        ];

        hjem.users.${user}.files = {
          ".config/starship.toml".source = ./configs/${starshipConfig}.toml;
        };
      };

    };
}

#  Starship must be initialized by a shell config file
