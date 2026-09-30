{ lib, config, ... }:
let
  cfg = config.mynix.hardware.memory.zram;
in
{
  config = lib.mkIf cfg.enable {
    zramSwap = {
      enable = true;
      priority = 100; # prioritize zram over swap
      algorithm = lib.mkDefault cfg.algorithm;
      memoryPercent = lib.mkDefault cfg.percentage;
    };
  };
}

/*
  ZRAM supports several compression algorithms, with the right choice depending
  on whether you prioritize saving memory or saving CPU time.

   Algorithm     Compression rate         CPU cost      Best use case
   ---------     ----------------         --------      -------------
   lz4           ~1.5/2 to 1              Very low      Memory-constrained systems
   zstd          ~3 to 1 (or higher)      Moderate      High-RAM systems (16GB+) as a fast buffer for memory spikes.

  To see which algorithms your kernel supports, use:
   `cat /sys/block/zram0/comp_algorithm`
  The algorithm currently in use is shown in [square brackets].
*/
