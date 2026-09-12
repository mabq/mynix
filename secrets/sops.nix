# Secrets are encrypted with the user's age key and are specific to each
# nixos-configuration (user + host + profile).
{
  config,
  lib,
  inputs,
  host,
  user,
  profile,
  ...
}:
let
  # The file containing age's private key (used to decrypt sops secrets).
  #
  #  This file must be created manually (or via `nixos-anywhere --extra-files`)
  #  at installation time. Without it the flake will fail to build.
  #
  #  Files passed via `nixos-anywhere --extra-files` are always owned by root.
  #  If we copy this file to its default location
  #  (`~/.config/sops/age/keys.txt`) then the `~/.config` directory ends up
  #  being owned by root, causing permission issues.
  #
  #  No need to check for this file's existence. Nix will skip secrets if it
  #  does not find it or if the key contained in it is not correct.
  #
  #  Make sure you quote the path, otherwise nix throws an error for trying to
  #  access files outside of the flake.
  ageKeyFile = "/var/lib/sops-nix/key.txt";

  # If no secrets' file is found, no secrets are configured.
  secretsFile = ./${user}-${host}-${profile}.json;
  secretsFileExist = builtins.pathExists secretsFile;

  # Sops only encrypts the value, not its attribute name. This is what makes it
  # possible for a secrets file to only define the secrets that it actually
  # needs, not all of them.
  sopsData = if secretsFileExist then builtins.fromJSON (builtins.readFile secretsFile) else { };
  # Remove the "sops" metadata attribute from the list.
  secretNames = builtins.attrNames (removeAttrs sopsData [ "sops" ]);

  hasSecrets = secretsFileExist && secretNames != [ ];

  # Set secrets owners/permissions and create symlinks
  #  https://github.com/mic92/sops-nix#set-secret-permissionowner-and-allow-services-to-access-it
  perSecretSettings = {
    "tailscaleAuthKey" = {
      # Tailscale is a system service, so no need to change ownership.
    };
    "sshKey" = {
      path = "/home/${user}/.ssh/id_ed25519";
      owner = user;
      mode = "0600";
    };
    "atuinKey" = {
      path = "/home/${user}/.local/share/atuin/key";
      owner = user;
      mode = "0600";
    };
  };
in
{
  # Since we don't put the private age file in its default location we need to
  # instruct the sops client where to find it.
  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = "${ageKeyFile}";
  };

  # sops = lib.mkIf hasSecrets {
  #   age.keyFile = ageKeyFile;
  #   defaultSopsFile = secretsFile;
  #   # This creates an attribute set where the keys are the secret's names and
  #   # their values are the attribute sets matching the perSecretsSettings
  #   # above.
  #   secrets = lib.genAttrs secretNames (name: perSecretSettings.${name} or { });
  # };

  home-manager = {
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
    users.${user} = {
      sops = lib.mkIf hasSecrets {
        age.keyFile = ageKeyFile;
        defaultSopsFile = secretsFile;
        # defaultSopsFormat = "json";
        # This creates an attribute set where the keys are the secret's names and
        # their values are the attribute sets matching the perSecretsSettings
        # above.
        secrets = lib.genAttrs secretNames (name: perSecretSettings.${name} or { });
      };
    };
  };

  # Remove stale secrets.
  #  sops-nix's own cleanup only runs when sops.secrets != {}, so it never
  #  prunes a previous generation once a profile has zero secrets. Clear the
  #  *contents* of the ramfs mount ourselves instead of removing the mount
  #  point (which the kernel won't allow while it's mounted).
  system.activationScripts.clear-stale-sops-secrets = lib.mkIf (!hasSecrets) (
    lib.stringAfter [ "users" "groups" ] ''
      for d in /run/secrets.d /run/secrets-for-users.d; do
        if [ -d "$d" ]; then
          find "$d" -mindepth 1 -delete 2>/dev/null || true
        fi
      done
      rm -f /run/secrets /run/secrets-for-users
    ''
  );

}
