{
  imports = [
    ../shared.nix
    ./hardware-configuration.nix
  ];

  # --- networking ---

  networking.hostName = "macbook";

  # - Use `ip a` to check network interfaces on each host.
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wls1b1.useDHCP = true;
}
