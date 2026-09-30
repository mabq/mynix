{
  config,
  lib,
  ...
}:
let
  cfg = config.mynix.services.tailscale;
  secrets = config.sops.secrets;
in
with lib;
{
  config = lib.mkIf cfg.enable {

    services.tailscale = {
      enable = mkDefault true;

      # If a tailscale authentication key is passed as a secret the machine is
      # authenticated automatically. Otherwise, login manually with `sudo
      # tailscale login`. For information about secrets see notes in that
      # module.
      authKeyFile = lib.mkIf (secrets ? "tailscaleAuthKey") secrets."tailscaleAuthKey".path;

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

  };
}
