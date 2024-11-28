{ pkgs, ... }:
{

  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      open
      yank
      sensible
      extrakto
      vim-tmux-navigator
    ];
    catppuccin = {
      enable = true;
      extraConfig = ''
        set -g @catppuccin_window_status_style "basic"
        set -g @catppuccin_window_current_text " #{b:pane_current_path}"
        set -g @catppuccin_window_text " #{b:pane_current_path}"
        set -g status-left ""
        set -g status-left-length 100
        set -g status-right-length 100
        set -g status-right "#{E:@catppuccin_status_application}"
        set -ag status-right "#{E:@catppuccin_status_session}"
      '';
    };
    extraConfig = ''
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
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
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"
    '';
  };

}
