{
  import = [
    ../shared.nix
    ./hardware-configuration.nix
  ];
  # ----------------------------------------------------------------------------

  networking.hostName = "nuc";
  networking.interfaces.enp1s0.useDHCP = true;

  # ----------------------------------------------------------------------------

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;

  # services.printing.enable = true;

  # ----------------------------------------------------------------------------
}
