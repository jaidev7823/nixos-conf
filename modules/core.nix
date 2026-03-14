{ config, pkgs, lib, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = 1;
    cores = 2;
    builders-use-substitutes = true;
    auto-optimise-store = true;
    trusted-users = [ "root" "jaidev" ];
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh.settings = {
    PermitRootLogin = "no";
    PasswordAuthentication = true;
  };

  zramSwap.enable = true;

  systemd.services.nix-daemon.serviceConfig = {
    AllowedCPUs = "0-3";
    CPUSchedulingPolicy = lib.mkForce "idle"; 
    Nice = 19;
    IOSchedulingClass = lib.mkForce "idle";
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    systemd-boot.extraEntries = {
      "windows.conf" = ''
        title Windows
        efi /EFI/Microsoft/Boot/bootmgfw.efi
        '';
    };
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    networkmanager.wifi.backend = "iwd";
    wireless.iwd.enable = true;
  };

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN"; LC_IDENTIFICATION = "en_IN"; LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN"; LC_NAME = "en_IN"; LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN"; LC_TELEPHONE = "en_IN"; LC_TIME = "en_IN";
  };
}
