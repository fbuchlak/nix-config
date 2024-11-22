{ my, pkgs, ... }:
{

  imports = my.lib.files.nix ./.;

  home.packages = with pkgs; [
    htop
  ];

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      open
      yank
      catppuccin
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set -g @catpuccin_flavour 'macchiato'
      set-environment -g COLORTERM "truecolor"
      set-option -g mouse on
      set -g base-index 1
      set -g pane-base-index 1
      set -g pane-base-index 1
      set -g renumber-windows on
      set -g mode-keys vi
      set -g status-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind C-l send-keys C-l
      bind C-\\ send-keys C-\\
    '';
  };

}
