{
  imports = [
    ../shared.nix
    ./hardware-configuration.nix
  ];

  # --- networking ---

  networking.hostName = "macbook";
}
