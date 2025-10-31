# mynix

## Install

- Clone this repository:

  `~/.local/share/mynix`

  Many files in this repo rely on this path.

- Change dir into the repository:

  `cd ~/.local/share/mynix`

- Run the command:

  `just deploy-<systemName>`

### Common errors

- "Failed to start Home Manager environment for <user>".

  This is because the build script could not override a file or symlink that is not pointing to the nix store.

## Why NixOS?

- Builtin rollbacks.

- Manage multiple hosts and users from a single repository.

- Single source for all packages. All cached, so no build required.

- Use stable versions for most packages and bleeding edge only for certain packages.

## Things to keep in mind

- Only lists merge automatically, attribute sets do not.
  Once you assign an attribute set to an attribute you will not be able to add another attribute set to that same attribute, even in another module.

