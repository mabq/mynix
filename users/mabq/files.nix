# - `outlink` symlinks files/directories out of store, meaning that changes
#   apply inmediatly without a rebuild.
#
# - Be careful when you link a whole directory, secret/private information
#   might be added to those directories later on. Linking the whole directory
#   will expose that information to the public repository.
#   For example: ssh and age directories will contain private keys.
#
# - The nix store is readable by all users, one should never put secret files
#   there.
{
  flakePath,
  configPath,
  outlink,
  theme,
  ...
}: {
  home.file = {
    ".config/age/key.txt.age".source = outlink "${configPath}/age/key.txt.age"; # - DO NOT LINK THE WHOLE DIRECTORY!
    ".config/btop".source = outlink "${configPath}/btop/";
    ".config/git/config".source = outlink "${configPath}/git/config";
    ".config/lazygit/config.yml".source = outlink "${configPath}/lazygit/config.yml";
    ".config/mynix/current/theme".source = outlink "${flakePath}/themes/${theme}";
    ".config/nvim".source = outlink "${configPath}/nvim/";
    ".config/starship.toml".source = outlink "${configPath}/starship/starship.toml";
    ".config/tmux/tmux.conf".source = outlink "${configPath}/tmux/tmux.conf";
    ".config/yazi".source = outlink "${configPath}/yazi/";
    # ".ssh/config".source = outlink "${configPath}/ssh/config"; # - DO NOT LINK THE WHOLE DIRECTORY!
    # ".ssh/id_ed25519.age".source = outlink "${configPath}/ssh/id_ed25519.age"; # - DO NOT LINK THE WHOLE DIRECTORY!
    # ".ssh/id_ed25519.pub".source = outlink "${configPath}/ssh/id_ed25519.pub"; # - DO NOT LINK THE WHOLE DIRECTORY!
    ".zshenv".source = ./config/zsh/.zshenv; # - No need for outlink
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };
}
