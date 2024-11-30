{ my, config, ... }:
let
  inherit (my.lib) xdg;
  gitlabConfig = "git/config-gitlab";
in
{

  home.shellAliases = {
    gst = "git status";
  };

  programs.git = {

    enable = true;

    userName = "fbuchlak";
    userEmail = "30214087+fbuchlak@users.noreply.github.com";
    includes = [
      {
        path = xdg.configPath config gitlabConfig;
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

  home.file."${xdg.configPathRel config gitlabConfig}".source = ./config/gitlab;

}
