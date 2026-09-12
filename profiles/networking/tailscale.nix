{ config, lib, ... }:
with lib;
{
  services.tailscale = {
    enable = mkDefault true;

    # Automatically login if an authKey is passed as a secret. Otherwise, login
    # manually with `sudo tailscale login`.
    authKeyFile = lib.mkIf (
      config ? sops.secrets."tailscaleAuthKey"
    ) config.sops.secrets."tailscaleAuthKey".path;

    # For all possible flags, see:
    #  https://tailscale.com/docs/reference/tailscale-cli#set
    extraUpFlags = [
      # Use the host name for tailcale. If that name is already taken a number
      # will be appended to it.
      "--hostname=${config.networking.hostName}"

      # Enable ssh access by default. Just make sure you have a proper access
      # policy in place.
      "--ssh"
    ];
  };
}
