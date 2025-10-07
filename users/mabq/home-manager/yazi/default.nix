# -- In the zsh module:
#    We add the `y` function in the aliases files that provides the ability to
#    change the current working directory when exiting yazi. See
#    https://yazi-rs.github.io/docs/quick-start#shell-wrapper
#
# -- In the tmux module:
#    We add some configuration options so that yazi image preview work when
#    in tmux. See https://yazi-rs.github.io/docs/image-preview#tmux
{
  config,
  pkgs,
  pkgs-unstable,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _config = "${repo}/modules/yazi/config";
in {
  home.packages = [
    # -- Install the most current version
    pkgs-unstable.yazi

    # -- Must have
    pkgs.file # for file type detection

    # -- Extend additional features with other command line tools
    pkgs.ffmpeg # -- for video thumbnails
    pkgs.p7zip # -- for archive extraction and preview, requires non-standalone version
    pkgs.jq # -- for JSON preview
    pkgs.poppler # -- for PDF preview
    pkgs.fd # -- for file searching
    pkgs.ripgrep # -- for file content searching
    pkgs.fzf # -- for quick file subtree navigation, (>= 0.53.0)
    pkgs.zoxide # -- for historical directories navigation (requires fzf)
    pkgs.resvg # -- for SVG preview
    pkgs.imagemagick # -- for Font, HEIC, and JPEG XL preview (>= 7.1.1)
    pkgs.wl-clipboard # -- for Linux clipboard support
    pkgs.dragon-drop # -- for dragon-drop
    pkgs.hyprpaper # -- for setting wallpaper
  ];

  # -- Config files
  #    Link the whole directory
  home.file.".config/yazi".source = _outOfStore "${_config}";
}
