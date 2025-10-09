{ 
  inputs,
  machine,
  user,
  # system
}: { 
  # This is a module, so we can use all automatically injected arguments here.
  config,
  ...
}: let
  # pkgsConfigs = {
  #   system = builtins.currentSystem;
  #   config.allowUnfree = true;
  # };
in {
  # Only works for home-manager modules when home-manager is installed as a
  # NixOS module.
  _module.args = rec {
    inherit inputs machine user;

    outlink = config.lib.file.mkOutOfStoreSymlink;

    # Out of store symlinks require absolute paths.
    flakePath = "/home/${user}/.local/share/mynix";
    userPath = "${flakePath}/users/${user}";

    # Expose both package sets to all modules.
    # pkgs = import inputs.nixpkgs pkgsConfigs;
    pkgsUnstable = import inputs.nixpkgs-unstable {
      config = config.nixpkgs.config;
    };
  };
}
