# Secrets depend on the combination of the user and profile. See notes on each
# secret below.
{
  lib,
  user,
  profile,
  ...
}:
let
  # The file containing the key to decrypt secrets (must be in place before
  # executing the flake).
  # ageKeyFile = "/home/${user}/.config/sops/age/keys.txt";
  ageKeyFile = "/var/lib/sops-nix/keys.txt";
  ageKeyFileExist = builtins.pathExists ageKeyFile;

  # If no secrets file is found, no secrets are configured.
  secretsFile = ./${user}/${profile}.json;
  secretsFileExist = builtins.pathExists secretsFile;

  # Sops only encrypts the value, not its attribute name. This is what makes it
  # possible for a secrets file to only define the secrets that it actually
  # needs, not all of them.
  sopsData = if secretsFileExist then builtins.fromJSON (builtins.readFile secretsFile) else { };
  # Remove the "sops" metadata attribute from the list.
  secretNames = builtins.attrNames (removeAttrs sopsData [ "sops" ]);

  hasSecrets = secretsFileExist && secretNames != [ ];

  # Sops stores all secrets in memory only. No secrets are leaked to the nix
  # store (which is public).
  #
  # All secrets exist in `/run/secrets/` (symlink to
  # `/run/secrets.d/<generation>/`) and are owned by root by default. Here you
  # can change the owner/group/mode of the secret file and also specify the
  # path where you would like a symlink to be created.
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
  # Show the sops client where to look for the private age key (required for
  # editing encrypted files).
  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = ageKeyFile;
  };

  sops = lib.mkIf (ageKeyFileExist && hasSecrets) {
    age.keyFile = ageKeyFile;
    defaultSopsFile = secretsFile;
    # This creates an attribute set where the keys are the secret's names and
    # their values are the attribute sets matching the perSecretsSettings
    # above.
    secrets = lib.genAttrs secretNames (name: perSecretSettings.${name} or { });
  };

  # Fix ownership of the age directory and key on every boot.
  #  Because you we copied `keys.txt` directly into the user's directory via
  #  `nixos-anywhere --extra-files` the file is owned by `root:root` on initial
  #  deployment. To ensure the user can read its own key when using `sops`, add
  #  a single tmpfiles rule to fix ownership automatically on boot.
  # NOTE: This should not be needed anymore, check after build
  # systemd.tmpfiles.rules = lib.mkIf ageKeyFileExist [
  #   "z /home/${user}/.config/sops/age/keys.txt 0600 ${user} users - -"
  # ];

  # Important! Remove secrets from old generations.
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
