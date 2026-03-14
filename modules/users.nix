{ pkgs, ... }:

{
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

  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "inode/directory" = "org.gnome.Nautilus.desktop";
    "text/plain" = "nvim.desktop";
    "text/markdown" = "nvim.desktop";
    "application/json" = "nvim.desktop";
    "application/pdf" = "org.gnome.Evince.desktop";
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "video/mp4" = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "audio/mpeg" = "mpv.desktop";
    "audio/flac" = "mpv.desktop";
    "application/zip" = "org.gnome.Nautilus.desktop";
    "application/x-tar" = "org.gnome.Nautilus.desktop";
  };
}
