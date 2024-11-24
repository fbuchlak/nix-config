{ lib, ... }:
{

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
      pull.rebase = true;
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

    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = lib.mkDefault true;
      };
    };

    aliases = {
      st = "status";
    };

  };

  home.file.".config/git/config-gitlab".source = ./config/gitlab;

}
