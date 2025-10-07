{
  config,
  pkgs,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _config = "${repo}/modules/nvim/config";
in {
  home.packages = [
    pkgs.nautilus

    # Auto-mount external disks to `/run/media/<user>/<label>`.
    # Installs `udisks2` as a dependency,
    # This is how Omarchy does it, see https://github.com/basecamp/omarchy/blob/master/install/omarchy-base.packages
    pkgs.gvfs
  ];

  # Link the whole directory out-of-store so that no rebuild is required to apply changes (must be an absolute path)
  # home.file.".config/nvim".source = _outOfStore "${_config}";
}
