# mynix

## Install

1. Clone this repository to `~/.local/share/mynix`.

   Many files in this repository assume this. If you clone to another path
   things won't work.


## Things to keep in mind

- Only lists merge automatically, attribute sets do not.
  Once you assign an attribute set to an attribute you will not be able to add another attribute set to that same attribute, even in another module.


## Common errors

- "Failed to start Home Manager environment for <user>".
  This is because the build script could not override a file or symlink that is not pointing to the nix store.

