# Secrets are encrypted with the user's age key and are specific to each
# nixos-configuration (user + host + profile).
{
  lib,
  host,
  user,
  profile,
  ...
}:
let
  # The file containing age's private key (used to decrypt sops secrets).
  #  The default location is `~/.config/sops/age/keys.txt`, but we need this
  #  file to be present before attempting installation. Files and directories
  #  passed via `nixos-anywhere --extra-files` are owned by root. If we copy
  #  the file to its default location `~/.config` would be owned by root,
  #  making it impossible for home-manager to write files inside it.
  # Do not check for this file's existence, when installing via
  # `nixos-anywhere` that evaluation happens on the source machine, not on the
  # target machine. Since this file is create manually before installation it
  # is assumed to exist on every installation.
  ageKeyFile = /var/lib/sops-nix/keys.txt;

  # If no secrets' file is found, no secrets are configured.
  secretsFile = ./${user}/${host}-${profile}.json;
  secretsFileExist = builtins.pathExists secretsFile;

  # Sops only encrypts the value, not its attribute name. This is what makes it
  # possible for a secrets file to only define the secrets that it actually
  # needs, not all of them.
  sopsData = if secretsFileExist then builtins.fromJSON (builtins.readFile secretsFile) else { };
  # Remove the "sops" metadata attribute from the list.
  secretNames = builtins.attrNames (removeAttrs sopsData [ "sops" ]);

  hasSecrets = secretsFileExist && secretNames != [ ];

  # Sops stores all secrets in memory (`/run/secrets/`). No secrets are leaked
  # to the nix store (which is public).
  #
  # All secrets are owned by root by default. Here you can change the
  # owner/group/mode of each secret and also specify a path if you would like
  # to create a symlink pointing to the secret.
  #
  # For programs that you configure via nixos/home-manager options, use
  # `config.sops.secrets.<secret-name>.path` to reference the secret file.
  perSecretSettings = {

    # The tailscale authkey depends on the user and profile. For example, the
    # same user would use one key for a server and another for his workstation.
    "tailscaleAuthKey" = {
      # Owned by root. No symlink required, passed to tailscale options.
    };

    # The private ssh key should only be included in profiles the user use to
    # accesses other machines, not on profiles that are normally accessed by
    # other machines.
    "sshKey" = {
      # SSH looks for the private key in this path. The file must be owned and
      # only readable by its user.
      path = "/home/${user}/.ssh/id_ed25519";
      mode = "0400";
      owner = "${user}";
    };

    # Only include an atuin key in profiles where you would like to sync
    # history.
    "atuinKey" = {
      # This will replace the random key created at installation so that you
      # don't have to enter it manually.
      path = "/home/${user}/.local/share/atuin/key";
      mode = "0600";
      owner = "${user}";
    };

  };
in
{
  # Since we don't put the private age file in its default location we need to
  # instruct the sops client where to find it.
  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = ageKeyFile;
  };

  sops = lib.mkIf hasSecrets {
    age.keyFile = ageKeyFile;
    defaultSopsFile = secretsFile;
    # This creates an attribute set where the keys are the secret's names and
    # their values are the attribute sets matching the perSecretsSettings
    # above.
    secrets = lib.genAttrs secretNames (name: perSecretSettings.${name} or { });
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
