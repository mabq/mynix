theme: {
  config,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _themes = "${repo}/modules/mynix/themes";
  _bin = "${repo}/modules/mynix/bin";
in {
  # Link theme
  home.file.".config/mynix/current/theme".source = _outOfStore "${_themes}/${theme}";

  # Link each binary
  home.file.".local/bin/mynix-theme-set".source = _outOfStore "${_bin}/mynix-theme-set";
}
