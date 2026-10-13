{
  flake.nixosModules.tailscale =
    { config, lib, ... }:
    let
      inherit (config.mynix) host;
    in
    {
      config = {
        services.tailscale = {
          enable = true;

          # If a tailscale authentication key is passed as a secret the machine is
          # authenticated automatically. Otherwise, login manually with `sudo
          # tailscale login`. For information about secrets see notes in that
          # module.
          authKeyFile = lib.mkIf (
            config ? sops.secrets."tailscaleAuthKey"
          ) config.sops.secrets."tailscaleAuthKey".path;

          # For all possible flags, see:
          #  https://tailscale.com/docs/reference/tailscale-cli#set
          extraUpFlags = [
            # Use the host name for tailcale. If that name is already taken a number
            # will be appended to it.
            "--hostname=${host}"
            # Enable ssh access by default. Just make sure you have a proper access
            # policy in place.
            "--ssh"
          ];
        };
      };
    };
}
