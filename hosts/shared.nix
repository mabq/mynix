{
  lib,
  pkgs,
  host,
  ...
}: {
  # --- boot ---

  # - Override the Linux kernel used by NixOS.
  #   Use the latest version available in nixpkgs.
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # - Use the systemd-boot EFI boot manager.
  boot.loader.systemd-boot = {
    enable = lib.mkDefault true;
    # - Limit the number of generations to keep to reduce disk usage.
    configurationLimit = lib.mkDefault 10;
  };

  # - Allow the installation process to modify EFI boot variables.
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # --- nix ---

  # - Use the latest version of the nix command throughout the system.
  nix.package = lib.mkDefault pkgs.nixVersions.latest;

  # - Nix settings, for possible settings see:
  #   https://nix.dev/manual/nix/2.28/command-ref/conf-file.html#available-settings
  nix.settings.auto-optimise-store = lib.mkDefault true;
  nix.settings.experimental-features = ["flakes" "nix-command"];

  # - Setup automatic gc to reduce disk usage.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # --- nixpkgs ---

  # - Nixpkgs configuration, for possible configuration options see:
  #   https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference.
  nixpkgs.config.enableParallelBuildingByDefault = lib.mkDefault false;
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # --- networking ---

  networking.hostName = lib.mkDefault host;

  # - Whether to use DHCP to obtain an IP address and other configuration for
  #   all network interfaces that do not have any manually configured IPv4
  #   addresses.
  #   Check available interfaces with `ip a`.
  networking.useDHCP = lib.mkDefault true;

  networking.firewall.enable = lib.mkDefault true;

  # --- bluetooth ---

  hardware.bluetooth.enable = lib.mkDefault true;
  hardware.bluetooth.powerOnBoot = lib.mkDefault true;
  hardware.bluetooth.settings = {
    General = {
      # - Shows battery charge of connected devices on supported Bluetooth
      #   adapters. Defaults to 'false'.
      Experimental = true;
      # - When enabled other devices can connect faster to us, however
      #   the tradeoff is increased power consumption. Defaults to 'false'.
      FastConnectable = true;
    };
    Policy = {
      # - Enable all controllers when they are found. This includes adapters
      #   present on start as well as adapters that are plugged in later on.
      #   Defaults to 'true'.
      AutoEnable = true;
    };
  };

  # --- users ---

  # - Discard any changes made to users or groups with imperative commands, so
  #   that users and groups always reflect declarative instructions.
  users.mutableUsers = lib.mkDefault false;

  # --- security ---

  # - Allow members of the wheel group to execute sudo actions without password.
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  # --- i18n ---

  i18n = {
    # - Determine the language for program messages, the format for dates and
    #   times, sort order, and so on.
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    # - Software to input symbols that are not available on standard input
    #   devices.
    # inputMethod = {
    #   enable = true;
    #   type = "fcitx5";
    #   fcitx5.addons = with pkgs; [
    #     fcitx5-chinese-addons
    #     fcitx5-gtk
    #     fcitx5-hangul
    #     fcitx5-mozc
    #   ];
    # };
  };

  # --- time ---

  time.timeZone = lib.mkDefault "America/Guayaquil";

  # --- fonts ---

  fonts.fontDir.enable = lib.mkDefault true;
  fonts.packages = [
    pkgs.nerd-fonts.caskaydia-mono
  ];

  # --- environment ---

  environment.systemPackages = [];

  # --- virtualization ---

  # virtualisation.docker.enable = lib.mkDefault true;
  # virtualisation.lxd = {
  #   enable = lib.mkDefault true;
  # };

  # --- openssh ---

  # - Be specific, so that you can override these on per-host basis.
  services.openssh.enable = lib.mkDefault true;
  services.openssh.settings.PermitRootLogin = lib.mkDefault "no";
  services.openssh.settings.PasswordAuthentication = lib.mkDefault true;

  # --- tailscale ---

  # - Manually authenticate with `sudo tailscale up`
  # services.tailscale.enable = lib.mkDefault true;

  # --- flatpak ---

  # services.flatpak.enable = lib.mkDefault true;

  # --- snap ---

  # services.snap.enable = lib.mkDefault true;

  # --- system ---

  # This value determines the NixOS release from which the default settings for
  # stateful data, like file locations and database versions on your system
  # were taken. It‘s perfectly fine and recommended to leave this value at the
  # release version of the first install of this system. Before changing this
  # value read the documentation for this option (e.g. man configuration.nix or
  # on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # -- Did you read the comment?
}
