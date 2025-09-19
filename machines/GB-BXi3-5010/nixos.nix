{ config, pkgs, lib, ... }:

{
  imports = [
    ../defaults.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nuc";
}
