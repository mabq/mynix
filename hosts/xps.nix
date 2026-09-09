# Options inherent to this machine only!
{ host, ... }:
let
  disk = "/dev/disk/by-id/wwn-0x5000cca55ff314ed";
in
{
  imports = [
    ./disko/ext4-encrypted.nix
  ];

  # -- Override imports --------------------------------------------------------

  # Use `lsblk -o NAME,ID-LINK` to check device's wwn id.
  #  "wwn" stands for World Wide Name, even if you buy two machines of the
  #  exact same model and specs, the hard drives or SSDs inside them will have
  #  different, unique WWNs.
  disko.devices.disk.main.device = disk;

  # -- Host specific options ---------------------------------------------------

  # Installer NixOS version
  #  Set it once at installation and never change it again.
  #  Use `nixos-version` on the ISO to check its version.
  system.stateVersion = "26.05";

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = disk; # (required by disko during installation)

  # Facter
  #  Newer versions of NixOS could take better decisions with the same report.
  hardware.facter.reportPath = ./facter/${host}.json;
}
