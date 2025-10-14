{
  imports = [
    ../shared.nix
    ./hardware-configuration.nix
  ];

  # --- networking ---

  networking.hostName = "nuc";

  # - Use `ip a` to check network interfaces on each host.
  networking.interfaces.enp1s0.useDHCP = true;

  # --- services ---

  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # services.printing.enable = true;
}
