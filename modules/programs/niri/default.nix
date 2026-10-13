{
  flake.nixosModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user niriConfig;
      dir = "/home/${user}/.local/share/mynix/modules/programs/niri";
    in
    {

      option = {
        mynix.niriConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected btop configuration";
        };
      };

      config = {
        programs.niri.enable = true;

        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
        };

        environment.systemPackages = with pkgs; [
          fuzzel # Wayland-native application launcher, similar to rofi’s drun mode
          foot # Fast, lightweight and minimalistic Wayland terminal emulator
          alacritty
          brave # Privacy-oriented browser for Desktop and Laptop computers
          nautilus # File manager for GNOME
        ];

        hjem.users.${user}.files = {
          ".config/niri".source = "${dir}/configs/${niriConfig}"; # out of store
        };
      };

    };
}
