_: {

  programs.git = {
    enable = true;

    userName = "fbuchlak";
    userEmail = "30214087+fbuchlak@users.noreply.github.com";
    includes = [
      {
        path = "~/.config/git/config-gitlab";
        condition = "hasconfig:remote.*.url:git@gitlab.com*/**";
      }
    ];

    extraConfig = {
      init.defaultBranch = "main";

      url = {
        "ssh://git@github.com/fbuchlak" = {
          insteadOf = "https://github.com/fbuchlak";
        };
        "ssh://git@gitlab.com/fbuchlak" = {
          insteadOf = "https://gitlab.com/fbuchlak";
        };
      };
    };

  };

  home.file.".config/git/config-gitlab".source = ./config/gitlab;

}
