# Themes

The source of all theme files is the `themes` directory at the root of this repository.

The current theme is defined by the symlink `~/.config/mynix/current/theme`, which points to the desired theme in `themes`.

Each program theme file is nothing more than a symlink poiting to `~/.config/mynix/current/theme/<program-theme-file>`.

There are applications that require environment variables, like `fzf` or `bat`.

