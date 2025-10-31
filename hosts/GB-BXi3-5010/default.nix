{
  imports = [
    ../system-defaults.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nuc";
}
