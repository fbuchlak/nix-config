{
  my,
  pkgs,
  config,
  ...
}:
let
  inherit (my.lib) xdg;
in
{

  programs.zsh = {

    dotDir = xdg.configPathRel config "zsh";
    enable = true;
    enableCompletion = true;

    autocd = true;
    autosuggestion.enable = true;

    syntaxHighlighting = {
      enable = true;
      catppuccin.enable = true;
    };

    history = {
      path = xdg.dataPath config "zsh/history";
      size = 50000;
      share = true;
      append = true;
      ignoreDups = true;
      ignoreSpace = true;
      ignoreAllDups = true;
      ignorePatterns = [
        "history"
        "exit|logout|clear"
        "..|~|cd|cd -|cd .."
        "l|la|ll|ls"
        "poweroff|sudo poweroff *|reboot|sudo reboot *|shutdown|sudo shutdown *"
        "rm *|rmdir *"
        "sh|zsh|bash|fish"
        "/nix/store*"
      ];
    };

    initExtraFirst = ''
      source ${./p10k.zsh}
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
    '';

    initExtra = ''
      stty start undef
      stty stop undef
      stty lnext undef

      setopt globdots interactive_comments
      ZSH_AUTOSUGGEST_MANUAL_REBIND=true

      function zvm_vi_yank () {
          zvm_yank
          printf %s "''${CUTBUFFER}" | ${pkgs.xclip}/bin/xclip -sel c
          zvm_exit_visual_mode
      }

      __zshrc_redraw () {
          local precmd
          for precmd in $precmd_functions; do
              $precmd
          done
          zle reset-prompt
      }
      zle -N __zshrc_redraw

      function __zshrc_custom_bindkeys () {
          bindkey '^ ' autosuggest-accept

          function __zshrc_dirup () {
              builtin cd ..
              zle __zshrc_redraw
          }
          zle -N __zshrc_dirup
          bindkey '^O' __zshrc_dirup

          function __zshrc_tmux () {
              if [[ -z "$TMUX" ]]; then
                  zle push-line
                  BUFFER="${pkgs.tmux}/bin/tmux"
                  zle accept-line
              fi
          }
          zle -N __zshrc_tmux
          bindkey '^B' __zshrc_tmux

          function __zshrc_cdfzf_file () {
              local selected_file
              selected_file=$(${pkgs.fd}/bin/fd -L -t f --min-depth 1 | ${pkgs.fzf}/bin/fzf)
              if [[ -n "$selected_file" ]]; then
                  builtin cd "$(dirname "$selected_file")"
              fi
              zle __zshrc_redraw
          }
          zle -N __zshrc_cdfzf_file
          bindkey '^F' __zshrc_cdfzf_file

          function __zshrc_cdfzf_dir () {
              local selected_dir
              selected_dir=$(${pkgs.fd}/bin/fd -L -t d --min-depth 1 --max-depth=3 | ${pkgs.fzf}/bin/fzf)
              if [[ -n "$selected_dir" ]]; then
                  builtin cd "$selected_dir"
              fi
              zle __zshrc_redraw
          }
          zle -N __zshrc_cdfzf_dir
          bindkey '^G' __zshrc_cdfzf_dir
      }


      __zshrc_custom_bindkeys
      zvm_after_init_commands+=(__zshrc_custom_bindkeys)
      zvm_after_lazy_keybindings_commands+=(__zshrc_custom_bindkeys)
    '';
  };

  persist.home.directories.data = [ "zsh" ];

}
