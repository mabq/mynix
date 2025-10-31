# - Set zsh as the default shell.
#
#   You should define the default shell in your NixOS module, and that shell’s
#   behavior and plugins in your Home Manager module.
#
#   NixOS decides which shell binary is launched by default for your user.
#   Home Manager configures what happens inside that shell (prompt, plugins, rc
#   files, etc).
#
#   Home Manager can change `$SHELL` inside your session, but it will not
#   update `/etc/passwd` or your login shell at the system level. That means
#   logging in via SSH or TTY might still use Bash. Zsh may only start after
#   you log in interactively.
#   So for clean, consistent behavior set it system-wide in NixOS.
{
  pkgs,
  user,
  ...
}: {
  # - Set default shell
  users.users.${user}.shell = pkgs.zsh;

  # - The user's default shell can only be set using a NixOS module.
  # programs.zsh = {
  #   # - Nix complains if we do not enable the default shell.
  #   enable = true;
  #   # - Since this NixOS module owns the zsh configuration these must also be
  #   #   placed here (not in the Home-manager module).
  #   autosuggestions.enable = true;
  #   syntaxHighlighting.enable = true;
  # };
}
