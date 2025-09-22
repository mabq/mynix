{ config, lib, pkgs, ... }: 

{
  programs.hyprland.enable = true;

  # Default hyprland config terminal
  environment.systemPackages = with pkgs; [
    kitty
  ];

  # Optional, hint electron apps to use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
