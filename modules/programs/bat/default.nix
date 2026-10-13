{
  flake.nixosModules.bat =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user theme batConfig;
      themePath = ./themes/${theme}.tmTheme;
    in
    {

      options = {

        mynix.batConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected bat configuration";
        };

      };

      config = {

        environment.systemPackages = with pkgs; [
          bat # Cat clone with syntax highlighting and Git integration
        ];

        hjem.users.${user}.files = {
          ".config/bat/config".source = ./configs/${batConfig};
          ".config/bat/themes/current.tmTheme".source = themePath;
        };

        # This user service rebuilds bat cache on theme change
        systemd.user.services.bat-cache = {
          description = "Rebuild bat cache on theme change";
          wantedBy = [ "default.target" ];
          restartTriggers = [ themePath ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.bat}/bin/bat cache --build";
          };
        };

      };

    };
}
