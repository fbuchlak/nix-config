_: {

  programs.brave = {
    enable = true;
    commandLineArgs = [ "--no-default-browser-check" ];
  };

  persist.home.directories.config = [ "BraveSoftware/Brave-Browser" ];
  persist.cache.directories.cache = [ "BraveSoftware/Brave-Browser" ];

}
