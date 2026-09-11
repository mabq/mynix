{
  configName ? "default",
}:
{
  self,
  pkgs,
  repoConfigDir,
  ...
}:
{
  # The keyd systemd service runs as root. It captures your input events,
  # remaps them, and emits them to the system at a low level.
  services.keyd.enable = true;

  environment = {
    systemPackages = [
      # Required to debug keycodes with `sudo keyd monitor`
      pkgs.keyd # Key remapping daemon for Linux
    ];

    # Keyd config files live in the `/etc` directory, so we cannot use
    # `mkOutOfStoreSymlink` with an absolute path.
    etc."keyd".source = self + repoConfigDir + "/keyd/${configName}";
  };
}
