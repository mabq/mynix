{
  flake.nixosModules.foot =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user theme footConfig;
    in
    {

      options = {
        mynix.footConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected foot configuration";
        };
      };

      config = {
        environment.systemPackages = with pkgs; [
          foot # Fast, lightweight and minimalistic Wayland terminal emulator
        ];

        hjem.users.${user}.files = {
          ".config/foot/foot.ini".source = ./configs/${footConfig}.conf;
          ".config/foot/theme.ini".source = ./themes/${theme}.theme;
        };
      };

    };
}
