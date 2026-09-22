{ lib, ... }:
{
  disko.devices.disk.main = {
    # device = # don't set a default value to avoid accidental overrides
    type = "disk";
    content = {
      type = "gpt";
      partitions = {

        # GRUB:
        #   The MBR/EF02 partition (BIOS boot partition) holds GRUB's core
        #   image when booting via legacy BIOS on a GPT disk. GRUB can't embed
        #   itself in the small gap before the first partition on GPT disks the
        #   way it can on MBR disks, so it needs this dedicated 1M partition to
        #   stash its second-stage bootloader.
        # systemd-boot:
        #   This partition is ignored on systems using systemd-boot.
        MBR = {
          type = "EF02"; # for grub MBR
          size = "1M";
          priority = 1; # needs to be first partition
        };

        # GRUB:
        #   The ESP/EF00 partition is used by GRUB when booting via UEFI.
        # systemd-boot:
        #   Boots entries from this partition.
        ESP = {
          type = "EF00";
          size = "500M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ]; # readable only by root
          };
        };

        # Root partition (boot-loader agnostic)
        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "crypted";
            # Small security risk in exchange of extended life time and
            # performance, only applies to SSDs.
            settings.allowDiscards = lib.mkDefault true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };

      };
    };
  };
}

/*
  Encryption password is prompted at installation.

  TRIM/discard tells an SSD which blocks are no longer in use so the drive can
  reclaim them (better performance + longevity). On encrypted or layered
  storage (LUKS, LVM, etc.), discards are disabled by default because they can
  leak information about which blocks are free. allowDiscards explicitly opts
  in to letting those commands through.
*/
