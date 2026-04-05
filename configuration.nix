{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/core.nix
    ./modules/desktop.nix
    ./modules/dev-tools.nix
    ./modules/packages.nix
    ./modules/users.nix
  ];

  system.stateVersion = "25.11";
}
