{
  lib,
  secrets,
  ...
}:
let
  ageKeyFile = "/var/lib/sops-nix/keys.txt";
  secretsFile = ./${secrets}.json;
  secretsFileExist = builtins.pathExists secretsFile;
  sopsData = if secretsFileExist then builtins.fromJSON (builtins.readFile secretsFile) else { };
  secretNames = builtins.attrNames (removeAttrs sopsData [ "sops" ]);
  hasSecrets = secretsFileExist && secretNames != [ ];
in
{
  environment.sessionVariables = {
    SOPS_AGE_KEY_FILE = ageKeyFile;
  };

  sops = lib.mkIf hasSecrets {
    age.keyFile = ageKeyFile;
    defaultSopsFile = secretsFile;
    secrets = lib.genAttrs secretNames (name: perSecretSettings.${name} or { });
  };
}
