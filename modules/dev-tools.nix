{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.resurrect
    ];
    extraConfig = ''
      # Restore Neovim sessions if a Session.vim file exists
      set -g @resurrect-strategy-nvim 'session'
      
      # Tell resurrect to specifically look for and restart these programs
      set -g @resurrect-processes 'nvim htop man less'
    '';
  };
}
