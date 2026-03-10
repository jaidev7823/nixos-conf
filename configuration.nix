# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

	programs.hyprland.enable = true;

	services.displayManager.sddm.enable = true;
	services.displayManager.defaultSession = "hyprland";

	services.xserver.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jaidev = {
    isNormalUser = true;
    description = "jai mishra";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


# --- Graphics / Nvidia Configuration ---
  
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true; # RTX 3060 supports the open kernel module
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
# 1. Enable nix-ld and specify the libraries it should use to fix Mason/LSPs
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    libxml2
  ];
environment.sessionVariables = {
  EDITOR = "nvim";
};

programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  
  # This is the "Omarchy" secret sauce
  ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" "history-substring-search" ];
  };
};

# Set Zsh as your default shell for your user
users.users.jaidev.shell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    # Terminal & Browser
    kitty
    chromium
    
    # Core Dev Tools
    neovim
    git
    gh
    lazygit
    tree-sitter
    ripgrep
    fd
    fzf
    gcc
    unzip
    gnumake # Added: Essential for compiling some Neovim plugins

    # File Management
    yazi
    glib # Provides 'gio' for trash support
    
    # LSPs & Formatters
    lua-language-server
    stylua
    nixd
    alejandra
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted

    # Document & Diagram Support (Fixes your Neovim errors)
    ghostscript
    tectonic
    mermaid-cli
    imagemagick

    # Hyprland Ecosystem
    waybar
    rofi # Fixed: Better for Wayland/Nvidia
    hyprpaper
    hyprlock
    wl-clipboard
    grim
    slurp
    playerctl
    brightnessctl
    networkmanagerapplet
    matugen

# --- Wallpaper & Graphics ---
    swww              # The missing piece for your wallpapers
    swaynotificationcenter # For swaync
    libnotify         # Needed for notifications to actually pop up
    
    # --- System Tray & Applets ---
    networkmanagerapplet # For nm-applet
    blueman              # For blueman-applet
    
    # --- Theme & Tools ---
    hyprpicker        # For the color picker bind ($mainMod, C)
    swappy            # For editing screenshots
    
    # --- Dependencies for your scripts ---
    bash
    coreutils
    findutils
    jq                # Many wallpaper scripts use jq to parse JSON
  ];

  # 2. Don't forget the Fonts! (Essential for Icons in LazyVim/Waybar)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
