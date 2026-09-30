{ user, ... }:
{
  imports = [
    # (import ./programs/wayland/niri.nix { })
    ./modules/compositor/hyprland.nix
  ];

  mynix.hardware = {
    network.manager = "systemd";
  };

  mynix.programs = {
    atuin.configName = "simple";
    git.configName = user;
    neovim.configName = user;
    starship.configName = "simple";
  };

  mynix.services = {
    plex.enable = true;
  };

}
