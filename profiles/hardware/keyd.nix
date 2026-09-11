{
  configName ? "default",
}:
{
  self,
  pkgs,
  user,
  repoConfigDir,
  ...
}:
{
  # The keyd systemd service runs as root. It captures your input events,
  # remaps them, and emits them to the system at a low level. It does not
  # require your user account to be in any group for the remaps themselves to
  # function.
  services.keyd.enable = true;

  # If you want to use non-root CLI tools (like `keyd monitor` to debug
  # keycodes), you need to explicitly declare the group in your NixOS config
  # and add your user to it.
  # users.groups."keyd" = { };
  # users.users.${user}.extraGroups = [ "keyd" ];

  environment = {
    systemPackages = [
      # This package is required to debug keycodes with `keyd monitor`
      pkgs.keyd # Key remapping daemon for Linux
    ];

    # Keyd config files live in the `/etc` directory, so we cannot use
    # `mkOutOfStoreSymlink` with an absolute path.
    etc."keyd".source = self + repoConfigDir + "/keyd/${configName}";
  };
}
