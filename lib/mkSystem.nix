{
  self,
  inputs,
}:
{
  host,
  user,
  profile,
  theme ? "tokyo-night",
  repoBranch ? "main",
}:
let
  # These variables are used across nix and configuration files to avoid
  # hard-coding paths. Abs (absolute) paths are mostly used to create
  # outOfStoreSymlinks. Non-abs paths are used in conjuction with `self` to
  # create paths relative to the flake root, instead of being relative to the
  # current module. Do a live-grep to see where each one is used.
  repoName = "mynix";
  repoUrl = "https://github.com/mabq/${repoName}.git";
  repoDir = "/home/${user}/.local/share/${repoName}";
  repoConfigDir = "/config";
  repoConfigDirAbs = repoDir + repoConfigDir;
  repoThemeDir = "${repoConfigDir}/${repoName}/themes/${theme}";
  repoThemeDirAbs = repoDir + repoThemeDir;
  localThemeDir = "/.config/${repoName}/theme";
  localThemeDirAbs = "/home/${user}" + localThemeDir;
  ageKeyFile = "/etc/${repoName}/sops/age/keys.txt";

  # `specialArgs` (unlike `_module.args`) does not cause infinite recursion
  # when using one of these in the `imports` section of another module.
  #  https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
  specialArgs = {
    inherit
      self
      inputs
      host
      user
      profile
      theme
      repoBranch
      repoName
      repoUrl
      repoDir
      repoConfigDir
      repoConfigDirAbs
      repoThemeDir
      repoThemeDirAbs
      localThemeDir
      localThemeDirAbs
      ageKeyFile
      ;
  };
in
inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;
  modules = [
    # Modules provided by the flake. Nix uses lazy-loading so it only loads
    # what is actually required.
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    # inputs.sops-nix.nixosModules.sops

    # Config files
    ../defaults
    ../hosts/${host}.nix
    ../users/${user}.nix
    ../profiles/${profile}.nix
  ];
}
