{...}: let
  configPath = ./config/source;
in {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  home.file.".zshenv".text = "ZDOTDIR=\"${configPath}\"";
}
