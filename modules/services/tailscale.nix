{
  config,
  lib,
  ...
}:
let
  cfg = config.mynix.services.tailscale;
in
with lib;
{
  config = lib.mkIf cfg.enable {

    services.tailscale = {
      enable = mkDefault true;

      # Login automatically if the tailscaleAuthKey is passed as a secret. The
      # key file is created by sops-nix at activation time in memory in
      # `/run/secrets/sshKey`. See notes in that module for more information.
      #
      # Otherwise, login manually with `sudo tailscale login`.
      authKeyFile =
        let
          secrets = config.sops.secrets;
        in
        lib.mkIf (secrets ? "tailscaleAuthKey") secrets."tailscaleAuthKey".path;

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
