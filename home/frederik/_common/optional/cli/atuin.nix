_: {

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;
    settings = {

      show_help = true;
      update_check = false;

      autosync = true;
      sync_address = "https://api.atuin.sh";
      sync_frequency = "1h";

      style = "full";
      invert = false;
      inline_height = 20;
      keymap_mode = "vim-insert";
      search_mode = "fuzzy";
      filter_mode = "host";
      filter_mode_shell_up_key_binding = "directory";

    };
  };
  catppuccin.atuin.enable = true;

  persist.home.directories.data = [ "atuin" ];

}
