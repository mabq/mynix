# This is not a nix module. It is just a helper function used by the flake.
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
      ;
  }
  // rec {
    # These variables are used across nix and configuration files to avoid
    # hard-coding paths. Absolute paths (abs) are mostly used to create
    # OutOfStoreSymlinks. Non-absolute paths are used in conjuction with `self`
    # to create paths relative to the flake root, instead of being relative to
    # the current module. Do a live-grep to see where each one is used.
    repoName = "mynix";
    repoUrl = "https://github.com/mabq/${repoName}.git";
    repoDir = "/home/${user}/.local/share/${repoName}";
    repoConfigDir = "/config";
    repoConfigDirAbs = repoDir + repoConfigDir;
    repoThemeDir = "${repoConfigDir}/${repoName}/themes/${theme}";
    repoThemeDirAbs = repoDir + repoThemeDir;
    localThemeDir = "/.config/${repoName}/theme";
    localThemeDirAbs = "/home/${user}" + localThemeDir;
  };

in

inputs.nixpkgs.lib.nixosSystem {
  inherit specialArgs;

  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops

    ../defaults
    ../secrets
    ../hosts/${host}.nix
    ../users/${user}.nix
    ../profiles/${profile}.nix
  ];
}
