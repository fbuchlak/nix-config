_: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      ll = "ls -alF --group-directories-first";
      gst = "git status";
    };
  };
}
