theme: {
  flakePath,
  userPath,
  outlink,
  ...
}: let
  m = "${userPath}/themes";
in {
  # - Set theme.
  #   All config files point to a fixed directory, when we set a theme all we
  #   need to do is change the content of that directory.
  home.file.".config/mynix/current/theme".source = outlink "${flakePath}/themes/${theme}";

  # - Link binaries.
  home.file.".local/bin/mynix-theme-set".source = outlink "${m}/bin/mynix-theme-set";
}
