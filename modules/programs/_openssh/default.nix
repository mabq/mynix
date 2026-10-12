{ lib, config, ... }:
{
  config =
    let
      inherit (config.mynix) user;
    in
    {

      flake.nixosModules.openssh =
        # This is the `config` that contains sops secrets
        { config, ... }:
        {

          # Configure ssh server
          #  Authorized public keys are set in the user's module
          services.openssh = {
            enable = true;
            settings = {
              PermitRootLogin = "no"; # Never!
              PasswordAuthentication = false; # No!, use Tailscale or ssh keys
            };
          };

          # The private key file is created by sops-nix (sops module) at
          # activation time in memory `/run/secrets/sshKey`.
          #
          # Here, we  create a symlink in `~/.ssh/id_ed25519` pointing to that
          # file in memory (this is where ssh expects to find the private key).
          #
          # Don't worry if you see `~/.ssh/id_ed25519` pointing to a file in the
          # `/nix/store/`, that is just another symlink pointing to the actual
          # secret file in memory. The symlink in the nix store only contains the
          # path to the secret, not the secret itself.
          #
          # Since the Nix store is world-readable, anyone on the system can see
          # that this symlink exists and see the path it points to, but they
          # can't read the secret file in memory without proper permissions.
          # Sops-nix configures the secret file to be owned and only readable by
          # the user.
          hjem.users.${user}.files = lib.mkIf (config.sops.secrets ? "sshKey") {
            ".ssh/id_ed25519".source = config.sops.secrets."sshKey".path;
          };

        };
    };
}
/*
  Related configs
  ---------------

  - Sops module creates the secret (if configured)
  - User's module configurures the public authorized key
*/
