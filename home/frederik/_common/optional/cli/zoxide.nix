_: {

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  persist.home.directories.data = [ "zoxide" ];

}
