{
  configName ? "default",
}:
{
  lib,
  pkgs,
  user,
  repoConfigDirAbs,
  ...
}:
{
  home-manager.users.${user} =
    { osConfig, config, ... }:
    let
      mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      home = {
        packages = with pkgs; [
          atuin # Replacement for a shell history
        ];

        file =
          lib.optionalAttrs (osConfig.sops.secrets ? "atuinKey") {
            # Replace atuin's random encryption key with our encryption key if
            # provided as a secret. For more details read notes in the openssh
            # module (similar situation).
            ".local/share/atuin/key" = {
              source = mkOutOfStoreSymlink osConfig.sops.secrets."atuinKey".path;
              force = true;
            };
          }
          // {
            ".config/atuin/config.toml" = {
              source = mkOutOfStoreSymlink "${repoConfigDirAbs}/atuin/${configName}.toml";
              force = true;
            };
          };
      };
    };
}

/*
  Related configs
  ---------------

  Must be initialized by a shell config file. In out zsh config we check if
  atuin is installed before initializing it. For more info, see:
    https://docs.atuin.sh/latest/guide/shell-integration/
    https://docs.atuin.sh/latest/configuration/key-binding/

  Sync history
  ------------

  This module enables Atuin and you can start using it right away, but if you
  want to sync history with another machine/s you must manually execute:

    `atuin login`

  The command will prompt you for a encryption key. If you include it as a
  secret it will be set automatically set, so you can just hit enter to skip.

  If you don't want to sync history with other machine/s, do not provide the
  encryption key as a secret and just press enter to use the random key created
  by atuin during installation.

  To manually enter the encryption key, first obtain the key from the password
  manager or by executing the following command in one of those machines:

    `atuin key`

  Enter the provided key. Atuin will replace the content of
  `~/.local/share/atuin/key` with it.

  Then, Atuin will open a web browser for you to authenticate (use your password
  manager). That's it!

  If you want to backup your history in atuin's servers, but not share it with
  other machines, you need to create a separate account.

  For more information, see:
   https://docs.atuin.sh/latest/guide
*/
