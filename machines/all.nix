{
  pkgs,
  lib,
  machine,
  ...
}: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  time.timeZone = lib.mkDefault "America/Guayaquil";

  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

  # environment.systemPackages = [];

  nix = {
    package = pkgs.nixVersions.latest;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  networking = {
    hostName = lib.mkDefault "${machine}";

    useDHCP = lib.mkDefault true;
    #interfaces.enp1s0.useDHCP = lib.mkDefault true;

    # Pick only one of the below networking options.
    # wireless.enable = lib.mkDefault true;  # Enables wireless support via wpa_supplicant.
    # networkmanager.enable = lib.mkDefault true;  # Easiest to use and most distros use this by default.

    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = lib.mkDefault [];
      allowedUDPPorts = lib.mkDefault [];
    };
  };

  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      # X11Forwarding = lib.mkDefault true;
      PermitRootLogin = lib.mkDefault "no"; # disable root login
      # PasswordAuthentication = lib.mkDefault false; # disable password login
    };
    openFirewall = lib.mkDefault true;
  };

  services.pipewire = {
    enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
  };

  services.printing = {
    # Enable CUPS to print documents
    enable = lib.mkDefault true;
  };

  # ------------------------------------------------------------------------- #

  # Do NOT change this value after the initial install, even if you've upgraded your
  # system to a new NixOS release. For more information, see `man configuration.nix`
  # or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}
