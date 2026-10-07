{ lib, ... }:
{
  options = {

    mynix = {

      host = lib.mkOption {
        type = lib.types.str;
        description = "Machine name";
      };

      timeZone = lib.mkOption {
        type = lib.types.enum [
          "America/Guayaquil"
        ];
        default = "America/Guayaquil";
        description = "Machine time zone";
      };

      isUEFI = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Host has UEFI firmware (set to false if BIOS)";
      };

      stateVersion = lib.mkOption {
        type = lib.types.enum [
          "26.05"
          "26.11"
        ];
        description = "NixOS installer version";
      };

      user = lib.mkOption {
        type = lib.types.str;
        description = "Primary user's name";
      };

      email = lib.mkOption {
        type = lib.types.str;
        description = "User's email (required for GitHub)";
      };

      theme = lib.mkOption {
        type = lib.types.enum [
          "catppuccin"
          "catppuccin-latte"
          "everforest"
          "gruvbox"
          "kanagawa"
          "nord"
          "rosepine"
          "tokyonight"
          "tokyonight-moon"
        ];
        default = "catppuccin";
        description = "System theme";
      };

    };

  };
}
