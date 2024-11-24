_: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    history.size = 50000;
    history.share = false;

    plugins = [ ];
  };
}
