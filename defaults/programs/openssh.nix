{ lib, user, ... }:
with lib;
{
  # Configure ssh server
  services.openssh = {
    enable = mkDefault true;
    settings = {
      PermitRootLogin = mkDefault "no"; # Never!
      PasswordAuthentication = mkDefault false; # No!, use Tailscale or ssh keys
    };
  };

  # To add the user's public key as an authorized key for this host, see the
  # user's file.

  # Create private key (if passed as a secret)
  home-manager.users.${user} =
    {
      osConfig,
      config,
      lib,
      ...
    }:
    lib.mkIf (osConfig.sops.secrets ? "sshKey") {
      home.file.".ssh/id_ed25519" = {
        # The private key file is created by sops-nix at activation time in
        # memory `/run/secrets/sshKey` . See notes in that module for more
        # information.
        #
        # Here, we use mkOutOfStoreSymlink to create a symlink in
        # `~/.ssh/id_ed25519` pointing to that file in memory.
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
        source = config.lib.file.mkOutOfStoreSymlink osConfig.sops.secrets."sshKey".path;
        force = true;
      };
    };
}
