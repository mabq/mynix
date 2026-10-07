{ lib, config, ... }:
{
  options = {
    mynix.bat.configName = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Bat configuration name";
    };
  };

  config =
    let
      inherit (config.mynix) user theme;
      themePath = ./themes/${theme}.tmTheme;
    in
    {
      flake.nixosModules.bat = { pkgs, ... }: {
        environment.systemPackages = with pkgs; [
          bat # Cat clone with syntax highlighting and Git integration
        ];

        hjem.users.${user}.files = {
          ".config/bat/config".source = ./configs/${config.mynix.bat.configName};
          ".config/bat/themes/current.tmTheme".source = themePath;
        };

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
