{...}: {
  imports = [
    ../defaults.nix
    ./hardware-configuration.nix
  ];

  # -- Specific properties of this machine:
  networking.hostName = "nuc";
}
