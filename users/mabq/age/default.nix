{
  pkgs,
  userPath,
  outlink,
  ...
}: let
  m = "${userPath}/age";
in {
  home.packages = [
    pkgs.age
  ];

  # -- Link config
  #    Do NOT link the whole directory!. This is where you will place the
  #    decrypted version of the key!
  #    Do NOT change the name of the key file, otherwise also update the script
  #    in this module.
  home.file.".config/age/key.txt.age".source = outlink "${m}/config/key.txt.age";

  # -- Link binaries
  #    Do NOT change the name of this script, otherwise also update `Justfile`.
  home.file.".local/bin/age-decrypt-secrets".source = outlink "${m}/bin/age-decrypt-secrets";
}
