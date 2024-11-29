_: {

  programs.brave = {
    enable = true;
    commandLineArgs = [ "--no-default-browser-check" ];
  };

  persist.home.symlinkDirectories = [ ".config/BraveSoftware/Brave-Browser" ];
  persist.cache.symlinkDirectories = [ ".cache/BraveSoftware/Brave-Browser" ];

}
