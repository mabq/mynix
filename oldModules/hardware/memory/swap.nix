# TIP: Before using this module try enabling zram.
{ lib, config, ... }:
let
  cfg = config.mynix.hardware.memory.swap;
in
{
  config = lib.mkIf cfg.enable {
    swapDevices = [
      {
        size = cfg.size; # size in MB
        device = "/var/lib/swapfile";
        priority = 5; # lower priority than zram
      }
    ];
  };
}
