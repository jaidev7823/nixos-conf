{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;

  environment.systemPackages = with pkgs; [
    # Development & Terminal
    neovim tmux kitty git gh lazygit yazi btop fastfetch
    ripgrep fd fzf jq tree-sitter gcc gnumake unzip
    python3 nodejs rustc cargo python3Packages.pip
    lsof nautilus evince imv mpv walker elephant 
    vscode

    
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
    chromium firefox opencode gemini-cli codex peacock
    imagemagick ghostscript tectonic mermaid-cli

    # System / Themes
    rose-pine-cursor hyprcursor glib coreutils
    sqlitebrowser sqlite
    postman

    #server 
    termius
  ];

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
}
