/*
  IMPORTANT!

  IF YOU PROVIDE A SECRETS FILE, YOU MUST ENSURE THAT THE PRIVATE KEY REQUIRED
  TO DECRYPT THAT FILE EXISTS. IF YOU FAIL TO PROVIDE THE KEY FILE THE BUILD
  WILL FAIL.
*/

{
  lib,
  host,
  user,
  profile,
  ...
}:
let
  # Secrets are specific to each "combined" configuration. So, each secret's
  # file must be named in the following shape.
  secretsFile = ./${user}-${host}-${profile}.json;
  secretsFileExist = builtins.pathExists secretsFile;

  # Why we use a system-level directory?
  #  Sops normally looks for the private key in `~/.config/sops/age/keys.txt`.
  #  We cannot use that (or any user's) directory because we use
  #  `nixos-anywhere --extra-files` to copy the key at installation time.
  #  `nixos-anywhere` runs as root, and when it does, none of the user's
  #  directories exist yet, so it will create those directories (including
  #  `~/.config`) and as a consequence all of those directories end up being
  #  owned by root, causing all sorts of permissions issues.
  #
  # Why don't we check for this file existance?
  #  `nixos-anywhere` works by building the system closure (and evaluating your
  #  flake) on the source machine, then it copies the resulting store paths
  #  (and anything passed via `--extra-files`) over to the target via
  #  SSH/kexec. So, `builtins.pathExists "/var/lib/sops-nix/key.txt"` would be
  #  asking if the file exist in the source machine — which is not only wrong,
  #  but can be confussing.
  ageKeyFile = "/var/lib/sops-nix/key.txt";

  # Sops only encrypts the secrets (the attributes values, not the attributes
  # names), this allow us to read the file before decryping it to process only
  # the secrets that each file actually defines (and not throw errors if a file
  # does not include any of the possible secrets).
  # (remove the "sops" attribute, it contains sops metadata)
  sopsData = if secretsFileExist then builtins.fromJSON (builtins.readFile secretsFile) else { };
  secretNames = builtins.attrNames (removeAttrs sopsData [ "sops" ]);

  hasSecrets = secretsFileExist && secretNames != [ ];

  # Set secrets owners/permissions
  #  https://github.com/mic92/sops-nix#set-secret-permissionowner-and-allow-services-to-access-it
  #
  # DO NOT CREATE SYMLINKS HERE!!!
  #  sops-nix is a system module, hence it is executed as root. If you create
  #  symlinks here those secrets (and their parent directories) will end up
  #  being owned by root, causing a lot of permissions issues! Let this module
  #  just create the secrets files in `/run/secrets/` with the proper
  #  owners/permissions. Symlinks to those secrets (where required) should be
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

  # Don't use the home-manager module, you would not be able to access secrets
  # from NixOS options (like tailscale).
  sops = lib.mkIf hasSecrets {
    age.keyFile = ageKeyFile;
    defaultSopsFile = secretsFile;
    # This creates an attribute set where the keys are the secret's names and
    # their values are the attribute sets matching the perSecretsSettings
    # above.
    secrets = lib.genAttrs secretNames (name: perSecretSettings.${name} or { });
  };

  # Update: Now it just works, keep it just in case.
  # Remove stale secrets. sops-nix's own cleanup only runs when sops.secrets !=
  # {}, so it never prunes a previous generation once a profile has zero
  # secrets. Clear the *contents* of the ramfs mount ourselves instead of
  # removing the mount point (which the kernel won't allow while it's mounted).
  # system.activationScripts.clear-stale-sops-secrets = lib.mkIf (!hasSecrets) (
  #   lib.stringAfter [ "users" "groups" ] ''
  #     for d in /run/secrets.d /run/secrets-for-users.d; do
  #       if [ -d "$d" ]; then
  #         find "$d" -mindepth 1 -delete 2>/dev/null || true
  #       fi
  #     done
  #     rm -f /run/secrets
  #   ''
  # );
}
