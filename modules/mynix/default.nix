theme: {
  config,
  repo,
  ...
}: let
  outOfStore = config.lib.file.mkOutOfStoreSymlink;
  thisModule = "${repo}/modules/mynix";
in {
  home.file.".config/mynix/current/theme".source = outOfStore "${thisModule}/themes/${theme}";

  # Link each binary
  home.file.".local/bin/mynix-theme-set".source = outOfStore "${thisModule}/bin/mynix-theme-set";
}
