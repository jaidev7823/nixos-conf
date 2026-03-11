{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Desktop
  programs.hyprland.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

environment.variables = {
  HYPRCURSOR_THEME = "";
  HYPRCURSOR_SIZE = "24";
  # Keep these for XWayland apps (like some browsers/IDEs)
  XCURSOR_THEME = "BreezeX-RosePine-Linux";
  XCURSOR_SIZE = "24";
};

environment.pathsToLink = [ "/share/icons" ];
# Networking
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd.enable = true; # Correct path for the iwd service
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Time / Locale
  time.timeZone = "Asia/Kolkata";

  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
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
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User
  users.users.jaidev = {
    isNormalUser = true;
    description = "jai mishra";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  # Nvidia
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # nix-ld
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
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
  };

programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  
  ohMyZsh = {
    enable = true;
    plugins = [ "git" ];
  };

  # This loads the theme and the config file
  promptInit = ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
  '';
};

  # Packages
  environment.systemPackages = with pkgs; [
    
    pulsemixer
    bluetui
    impala
    lazydocker
    btop
    fastfetch
    wlogout
    tmux
    cava
    rose-pine-cursor
    hyprcursor
    kitty
    chromium

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
    gnumake

    yazi
    glib

    lua-language-server
    stylua
    nixd
    alejandra
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted

    ghostscript
    tectonic
    mermaid-cli
    imagemagick

    waybar
    rofi
    hyprpaper
    hyprlock
    wl-clipboard
    grim
    slurp
    playerctl
    brightnessctl
    networkmanagerapplet
    matugen

    swww
    swaynotificationcenter
    libnotify

    blueman
    hyprpicker
    swappy

    bash
    coreutils
    findutils
    jq
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  system.stateVersion = "25.11";
}
