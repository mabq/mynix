{
  flake.nixosModules.openssh =
    { config, lib, ... }:
    let
      inherit (config.mynix) user;
    in
    {

      config = {

        services.openssh = {
          enable = true;
          settings = {
            # Only allow access with ssh keys (authorized keys are set in the
            # user's module)
            PermitRootLogin = "no"; # Never!
            PasswordAuthentication = false; # No!
          };
        };

        # The private key file is created by sops-nix (sops module) in memory
        # `/run/secrets/sshKey` at activation time. Here, we create a symlink
        # in `~/.ssh/id_ed25519` pointing to that file in memory (this is where
        # ssh expects to find the private key).
        hjem.users.${user}.files = lib.mkIf (config ? sops.secrets."sshKey") {
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
