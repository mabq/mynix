# mynix

Clone this repo to `~/.local/share/mynix/`, otherwise update `/lib/mksystem.nix` with the correct path.


## Keep in mind

- Only lists merge automatically.
  Assigning other type of values to the same attribute more than once will throw an error, because nix would be overriding one.
  Prefer detailed assingments, e.g. `a.b.c.d.e` to avoid setting a value to parent attribute.
