{ lib, config, ... }:
{
  options = {
    mynix.btop.configName = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Btop configuration name";
    };
  };

  config =
    let
      inherit (config.mynix) user theme;
    in
    {
      flake.nixosModules.btop = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
          btop # Monitor of resources
        ];

        hjem.users.${user}.files = {
          ".config/btop/btop.conf".source = ./configs/${config.mynix.btop.configName}.conf;
          ".config/btop/themes/current.theme".source = ./themes/${theme}.theme;
        };
      };
    };

}
