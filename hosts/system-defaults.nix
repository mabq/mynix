# - Use long-term descriptors (a.b.c.d.e = x)
#   This allows you to override any given option in host-specific files.
#
# - Use `lib.mkDefault`, otherwise you won't be able to override the given
#   option.
{
  lib,
  pkgs,
  host,
  ...
}: {
  # - Use the latest version of the linux kernel available in nixpkgs.
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # - Use the systemd-boot EFI boot manager.
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  # - Limit the number of generations to keep to reduce disk usage.
  boot.loader.systemd-boot.configurationLimit = lib.mkDefault 10;

  # - Allow the installation process to modify EFI boot variables.
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # ---

  # - Use the latest version of the nix command throughout the system.
  nix.package = lib.mkDefault pkgs.nixVersions.latest;

  # - Nix settings.
  #   https://nix.dev/manual/nix/2.28/command-ref/conf-file.html#available-settings
  nix.settings.auto-optimise-store = lib.mkDefault true;
  #   https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix.html
  nix.settings.experimental-features = ["flakes" "nix-command"];
  #   https://nix.dev/manual/nix/2.28/package-management/garbage-collection.html
  nix.extraOptions = ''
    keep-derivations = true
    keep-outputs = true
  '';

  # - Setup automatic gc to reduce disk usage.
  nix.gc.automatic = lib.mkDefault true;
  nix.gc.dates = lib.mkDefault "weekly";
  nix.gc.options = lib.mkDefault "--delete-older-than 1w";

  # ---

  # - Nixpkgs configuration, for possible configuration options see:
  #   https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference.
  nixpkgs.config.enableParallelBuildingByDefault = lib.mkDefault false;
  nixpkgs.config.allowUnfree = lib.mkDefault true;

  # ---

  # - Enable wifi
  #   iwd is the modern alternative to wpa_supplicant
  networking.wireless.iwd.enable = lib.mkDefault true;

  networking.hostName = lib.mkDefault host;

  # - Whether to use DHCP to obtain an IP address and other configuration for
  #   all network interfaces that do not have any manually configured IPv4
  #   addresses.
  #   Check available interfaces with `ip a`.
  networking.useDHCP = lib.mkDefault true;

  networking.firewall.enable = lib.mkDefault true;

  # ---

  hardware.bluetooth.enable = lib.mkDefault true;

  # --- pipewire ---
  services.pipewire = {
    enable = lib.mkDefault true;
    alsa.enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    jack.enable = lib.mkDefault true;
    # wireplumber.enable = lib.mkDefault true;
  };
  # Give pipewire permission to run in realtime priority (avoid audio lags)
  security.rtkit.enable = true;

  # ---

  # - Discard any changes made to users or groups with imperative commands, so
  #   that users and groups always reflect declarative instructions.
  users.mutableUsers = lib.mkDefault false;

  # - Allow members of the wheel group to execute sudo actions without password.
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  # ---

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

  # ---

  time.timeZone = lib.mkDefault "America/Guayaquil";

  # ---

  fonts.fontDir.enable = lib.mkDefault true;
  # fonts.packages = [
  #   pkgs.nerd-fonts.caskaydia-mono
  # ];

  # ---

  # - Server-side ssh
  services.openssh.enable = lib.mkDefault true;
  services.openssh.settings.PermitRootLogin = lib.mkDefault "no";
  services.openssh.settings.PasswordAuthentication = lib.mkDefault true;

  # - Manually authenticate with `sudo tailscale up`
  # services.tailscale.enable = lib.mkDefault true;

  # services.flatpak.enable = lib.mkDefault true;

  # services.snap.enable = lib.mkDefault true;

  # ---

  # virtualisation.docker.enable = lib.mkDefault true;
  # virtualisation.lxd = {
  #   enable = lib.mkDefault true;
  # };

  # ---

  # This value determines the NixOS release from which the default settings for
  # stateful data, like file locations and database versions on your system
  # were taken. It‘s perfectly fine and recommended to leave this value at the
  # release version of the first install of this system. Before changing this
  # value read the documentation for this option (e.g. man configuration.nix or
  # on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # -- Did you read the comment?
}
