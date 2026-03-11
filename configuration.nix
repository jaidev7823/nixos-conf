{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # --- 1. SYSTEM CORE & NIX SETTINGS ---
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    max-jobs = 1;
    cores = 4;
    builders-use-substitutes = true;
    auto-optimise-store = true;
  };

  # Modern way to prevent Nix from hanging the UI
  systemd.services.nix-daemon.serviceConfig = {
    AllowedCPUs = "0-3";    # Locks Nix to the first 4 cores
    CPUSchedulingPolicy = "idle"; # Only uses CPU when nothing else wants it
    Nice = 19;              # Lowest possible CPU priority
    IOSchedulingClass = "idle";   # Lowest possible Disk priority
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
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
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # --- 4. USERS & SHELL ---
  users.users.jaidev = {
    isNormalUser = true;
    description = "jai mishra";
    extraGroups = [ "networkmanager" "wheel" ];
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

  environment.systemPackages = with pkgs; [
    # Development & Terminal
    neovim tmux kitty git gh lazygit yazi btop fastfetch
    ripgrep fd fzf jq tree-sitter gcc gnumake unzip
    python3 nodejs rustc cargo python3Packages.pip
    
    # LSP & Formatting
    lua-language-server stylua nixd alejandra
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted

    # Wayland / Hyprland Tools
    waybar rofi hyprpaper hyprlock swww swaynotificationcenter
    libnotify wl-clipboard grim slurp satty swappy hyprpicker
    playerctl brightnessctl networkmanagerapplet matugen wlogout
    
    # Media & CLI Tools
    pulsemixer pamixer bluetui impala lazydocker cava
    chromium opencode gemini-cli codex peacock
    imagemagick ghostscript tectonic mermaid-cli
    
    # System / Themes
    rose-pine-cursor hyprcursor glib coreutils
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
