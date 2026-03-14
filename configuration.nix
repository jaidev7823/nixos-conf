{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];
# --- 1. SYSTEM CORE & NIX SETTINGS ---
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
# Prevent freezing if RAM fills up
  zramSwap.enable = true;
  virtualisation.podman.enable = true; 
  systemd.services.nix-daemon.serviceConfig = {
    AllowedCPUs = "0-3";
# Use mkForce to override the default "other" policy
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

# --- 2. DESKTOP & GRAPHICS (NVIDIA) ---
  programs.hyprland.enable = true;
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "hyprland";
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    xkb.layout = "us";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
  };

# --- 3. AUDIO & BLUETOOTH ---
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
# hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

# --- 4. USERS & SHELL ---
  users.users.jaidev = {
    isNormalUser = true;
    description = "jai mishra";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
    };
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      '';
  };

# --- 5. ENVIRONMENT & PACKAGES ---
  nixpkgs.config.allowUnfree = true;

  environment.variables = {
    HYPRCURSOR_THEME = "";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "BreezeX-RosePine-Linux";
    XCURSOR_SIZE = "24";
  };
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [
# Development & Terminal
    neovim tmux kitty git gh lazygit yazi btop fastfetch
      ripgrep fd fzf jq tree-sitter gcc gnumake unzip
      python3 nodejs rustc cargo python3Packages.pip
      lsof 
# LSP & Formatting
      lua-language-server stylua nixd alejandra
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted

# Wayland / Hyprland Tools
      waybar rofi hyprpaper hyprlock swww swaynotificationcenter
      libnotify wl-clipboard grim slurp satty swappy hyprpicker
      playerctl brightnessctl networkmanagerapplet matugen wlogout
      cliphist wl-clipboard peaclock 

# Media & CLI Tools
      pulsemixer pamixer bluetui impala lazydocker cava
      chromium opencode gemini-cli codex peacock
      imagemagick ghostscript tectonic mermaid-cli

# System / Themes
      rose-pine-cursor hyprcursor glib coreutils

# database
      sqlitebrowser sqlite

# https
      postman
      ];

# --- 6. EXTRA PROGRAMS & SERVICES ---
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc zlib fuse3 icu nss openssl curl expat libxml2
    ];
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
      font-awesome
  ];

  system.stateVersion = "25.11";
}
