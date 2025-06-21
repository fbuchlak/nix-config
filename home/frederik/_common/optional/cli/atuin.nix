_: {

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = false;

    settings = {
      autosync = true;
      sync_address = "https://api.atuin.sh";
      sync_frequency = "1h";

      update_check = false;

      show_help = true;
      search_mode = "fuzzy";

    };
  };

  persist.home.directories.data = [ "atuin" ];

}
