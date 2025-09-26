{...}: {
  imports = [
    ./hardware-configuration.nix
    ../all.nix
    ../../modules/keyd
  ];

  # -- Specific properties of this machine:
  networking.hostName = "nuc";
}
