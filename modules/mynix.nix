{ lib, ... }:
{
  options = {

    mynix = {

      host.name = lib.mkOption {
        type = lib.types.str;
        description = "Machine name";
      };

      host.biosFirmware = lib.mkOption {
        # UEFI by default
        type = lib.types.bool;
        default = false;
        description = "Host has BIOS firmware";
      };

      host.stateVersion = lib.mkOption {
        type = lib.types.enum [
          "26.05"
          "26.11"
        ];
        description = "NixOS installer version";
      };

      user.name = lib.mkOption {
        type = lib.types.str;
        description = "Primary user's name";
      };

      user.email = lib.mkOption {
        type = lib.types.str;
        description = "User's email (required for GitHub)";
      };

    };

  };
}
