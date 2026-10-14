{
  flake.nixosModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user host niriConfig;
      dir = "/home/${user}/.local/share/mynix/modules/programs/niri";
    in
    {

      options = {
        mynix.niriConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected btop configuration";
        };
      };

      config = {
        programs.niri.enable = true;

        environment.systemPackages = with pkgs; [
          fuzzel # Wayland-native application launcher, similar to rofi’s drun mode
          foot # Fast, lightweight and minimalistic Wayland terminal emulator
          brave # Privacy-oriented browser for Desktop and Laptop computers
          nautilus # File manager for GNOME
        ];

        hjem.users.${user}.files = {
          ".config/niri".source = "${dir}/configs/${niriConfig}"; # out of store

          # Disable macbook phantom display
          ".config/mynix/niri/outputs.kdl".text = lib.mkIf (host == "macbook") ''
            output "LVDS-1" {
                off
            }
          '';
        };
      };

    };
}
