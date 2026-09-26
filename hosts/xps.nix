# Options inherent to this machine only!
# Use hardware-configuration or facter, not both [1]
{
  inputs,
  host,
  ...
}:
{
  imports = [
    ./disko/ext4-encrypted.nix
    # ./hardware-configuration/${host}.nix # [1]
  ];

  # Disko
  #  Use `lsblk -o NAME,ID-LINK` to check device's wwn id.
  #  "wwn" stands for World Wide Name, even if you buy two machines of the
  #  exact same model and specs, the hard drives or SSDs inside them will have
  #  different, unique wwn's.
  disko.devices.disk.main.device = "/dev/disk/by-id/wwn-0x5000cca55ff314ed";

  # Facter
  #  Newer versions of NixOS could take better decisions with the same report.
  hardware.facter.reportPath = ./facter/${host}.json; # [1]

  # System state version
  #  Records the NixOS release this machine was first installed on. It is there
  #  so stateful data (data that survives rebuilds and upgrades, such as
  #  databases, passwords, or application files) keeps working when everything
  #  around it moves on. So you set it during installation, and then you leave
  #  it alone forever. Bumping it because a newer number exists is not an
  #  upgrade. Use `nixos-version` on the ISO to check its version.
  system.stateVersion = "26.05";

  # Grub
  #  Works for both EFI and BIOS systems. It's not necessary to set
  #  `boot.loader.grub.device` here, Disko will take care of that.
  #  https://github.com/nix-community/disko/blob/master/docs/quickstart.md
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  # On UEFI, systemd-boot is recommended over GRUB
  # boot.loader = {
  #   systemd-boot.enable = true;
  #   efi.canTouchEfiVariables = true;
  # };
}
