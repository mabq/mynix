# Zsh

The user's default shell is defined in `etc/password`, a file owned by `root`, hence requiring `root` privileges to change it. In NixOS this can only be done with a NixOS module, not Home-manager.

Because of this we have to split the zsh configuration between a NixOS and a Home-manager module, both inside the user's directory. In the NixOS module we instruct nix to use zsh as the default shell and since that module owns the zsh configuration we also have to enable zsh plugins there. The home-manger module is only used to symlink zsh config files.

The `.zshenv` file sets the `ZDOTDIR` variable instructing zsh to look for all configurations files in a given directory. We make zsh point to the config files in this repository.

## Init

Unlike other distros, installing zsh plugins in NixOS will place files in the nix store. So we only initialize those if the files are present (no change required if changing distro).

Zoxide, atuin and starship are initialized automatically.

## Outside configurations

Zsh automatically adds a file called `.zcompdump` to the directory where zsh configuration files reside. So we need to use `.gitignore` to ignore that file.
