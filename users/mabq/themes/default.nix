theme: {
  config,
  outlink,
  flakePath,
  userPath,
}: let
  binPath = "${userPath}/themes/bin",
in {
  # Link theme. All package config files point to a fixed directory for theming
  # purposes, here we change where that directory points to.
  home.file.".config/mynix/current/theme".source = outlink "${flakePath}/themes/${theme}";

  # Link binary.
  home.file.".local/bin/mynix-theme-set".source = outlink "${binPath}/mynix-theme-set";
}
