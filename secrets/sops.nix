# Secrets are encrypted with the user's age key and are specific to each
# combined configuration (user + host + profile).
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
  # This is the file containing the user's private age key required to decrypt
  # sops secrets.
  #
  # By default, `sops` looks for this file in `~/.config/sops/age/keys.txt`. We
  # cannot use that location because when `nixos-anywhere --extra-files` copies
  # files it also creates all the required  parent directories, and all those
  # end up being owned by root, making impossible for tools like home-manager
  # to write inside it. Therefore, we use a system directory, where files can
  # be owned by root.
  #
  # There is no need to check for this file's existence. Nix will simply skip
  # secrets if the key file does not exist. Make sure you quote the path,
  # otherwise nix throws an error because flakes cannot reference external
  # files.
  ageKeyFile = "/var/lib/sops-nix/key.txt";
  ageKeyFileExist = builtins.pathExists ageKeyFile;

  # Secrets are optional, if no secrets file is found no secrets are set. Each
  # secrets file should only contain the keys actually required for that
  # configuration.
  secretsFile = ./${user}-${host}-${profile}.json;
  secretsFileExist = builtins.pathExists secretsFile;

  # Sops only encrypts the secrets (the attributes values, not the attributes
  # names), this allow us to read the file before decryping it to process only
  # the secrect that each file defines (and not throw errors if a file does not
  # include any of the possible secrets).
  sopsData = if secretsFileExist then builtins.fromJSON (builtins.readFile secretsFile) else { };
  # Remove the "sops" attribute, it contains sops metadata.
  secretNames = builtins.attrNames (removeAttrs sopsData [ "sops" ]);

  hasSecrets = ageKeyFileExist && secretsFileExist && secretNames != [ ];

  # Set secrets owners/permissions
  #  https://github.com/mic92/sops-nix#set-secret-permissionowner-and-allow-services-to-access-it
  #
  # IMPORTANT!
  #  Do not create symlinks here, these symlinks are created by nixos (not
  #  home-manager), when evaluating the flake for the first time with
  #  `nixos-anywhere` none of the user directories exist yet, so those
  #  directories are created and owned by root, causing permission issues. Let
  #  this module just create the secrets in `/run/secrets/` with the proper
  #  owners/permissions. Symlinks to those secrets (when required) should be
  #  created by the modules using them (with home-manager).
  perSecretSettings = {
    "tailscaleAuthKey" = {
      # Tailscale is a system service. No need to change ownership.
    };
    "sshKey" = {
      # path = "/home/${user}/.ssh/id_ed25519"; # DON'T!!!!!
      owner = user;
      mode = "0600";
    };
    "atuinKey" = {
      # path = "/home/${user}/.local/share/atuin/key"; # DON'T!!!!!
      owner = user;
      mode = "0600";
    };
  };
in
{
  environment.sessionVariables = {
    # Since we don't use the default directory for the key, we must show sops
    # where to find it.
    SOPS_AGE_KEY_FILE = "${ageKeyFile}";
  };

  sops = lib.mkIf hasSecrets {
    age.keyFile = ageKeyFile;
    defaultSopsFile = secretsFile;
    # This creates an attribute set where the keys are the secret's names and
    # their values are the attribute sets matching the perSecretsSettings
    # above.
    secrets = lib.genAttrs secretNames (name: perSecretSettings.${name} or { });
  };

  # Remove stale secrets. sops-nix's own cleanup only runs when sops.secrets !=
  # {}, so it never prunes a previous generation once a profile has zero
  # secrets. Clear the *contents* of the ramfs mount ourselves instead of
  # removing the mount point (which the kernel won't allow while it's mounted).
  system.activationScripts.clear-stale-sops-secrets = lib.mkIf (!hasSecrets) (
    lib.stringAfter [ "users" "groups" ] ''
      for d in /run/secrets.d /run/secrets-for-users.d; do
        if [ -d "$d" ]; then
          find "$d" -mindepth 1 -delete 2>/dev/null || true
        fi
      done
      rm -f /run/secrets.d /run/secrets
    ''
  );
}
