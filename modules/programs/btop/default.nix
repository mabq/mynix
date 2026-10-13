{
  flake.nixosModules.btop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user theme btopConfig;
    in
    {

      options = {
        mynix.btopConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected btop configuration";
        };
      };

      config = {
        environment.systemPackages = with pkgs; [
          btop # Monitor of resources
        ];

        hjem.users.${user}.files = {
          ".config/btop/btop.conf".source = ./configs/${btopConfig}.conf;
          ".config/btop/themes/current.theme".source = ./themes/${theme}.theme;
        };
      };

    };
}
