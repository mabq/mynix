{
  config,
  pkgs,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _config = "${repo}/modules/age/config";
  _bin = "${repo}/modules/age/bin";
in {
  home.packages = [
    pkgs.age
  ];

  # -- Link config
  #    Do NOT link the whole directory!. This is where you will place the
  #    decrypted version of the key!
  #    Do NOT change the name of this file, otherwise also update the script
  #    in this module, it expects to find this file.
  home.file.".config/age/key.txt.age".source = _outOfStore "${_config}/key.txt.age";

  # -- Link binaries
  #    Do NOT change the name of this script, otherwise also update `Justfile`.
  home.file.".local/bin/age-decrypt-secrets".source = _outOfStore "${_bin}/age-decrypt-secrets";
}
