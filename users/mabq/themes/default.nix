# - Theme files are placed at the root of the repository because those are
#   meant to be shared by all users. Here, we symlink a user file to the
#   desired theme.
theme: {
  flakePath,
  userPath,
  outlink,
  ...
}: let
  m = "${userPath}/themes";
in {
  # - Set theme
  #   All config files point to a fixed directory, when we set a theme all we
  #   do is change the symlink to point to a different theme directory.
  home.file.".config/mynix/current/theme".source = outlink "${flakePath}/themes/${theme}";

  # - Link binaries
  home.file.".local/bin/mynix-theme-set".source = outlink "${m}/bin/mynix-theme-set";
}
