{ user, profile, ... }:
{
  imports = [
    ./hardware/zram.nix
    (import ./hardware/keyd.nix { })

    ./networking/systemd-networkd.nix

    (import ./programs/atuin.nix { configName = "simple"; })
    (import ./programs/bat.nix { })
    (import ./programs/btop.nix { })
    (import ./programs/git.nix { configName = user; })
    (import ./programs/neovim.nix { configName = user; })
    (import ./programs/starship.nix { configName = "simple"; })
    (import ./programs/tmux.nix { })
    (import ./programs/yazi.nix { })
    (import ./programs/zsh.nix { })

    (import ./programs/foot.nix { })
    # (import ./programs/wayland/niri.nix { })

    ./modules/compositor/hyprland.nix
  ];

  services.plex = {
    # Configure Plex via `http://<SERVER-IP>:32400/web`
    enable = true;
    openFirewall = true;
    user = config.users.users.${user}.name; # ⚠️ should not run as my user, it could read secret files only readble by me
  };
}
