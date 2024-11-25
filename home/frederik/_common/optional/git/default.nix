{
  my,
  lib,
  config,
  ...
}:
{

  programs.git = {
    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = lib.mkDefault "always";
      };
    };
    aliases = {
      st = "status";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        activeBorderColor = [
          "#89b4fa"
          "bold"
        ];
        inactiveBorderColor = [ "#a6adc8" ];
        optionsTextColor = [ "#89b4fa" ];
        selectedLineBgColor = [ "#313244" ];
        cherryPickedCommitBgColor = [ "#45475a" ];
        cherryPickedCommitFgColor = [ "#89b4fa" ];
        unstagedChangesColor = [ "#f38ba8" ];
        defaultFgColor = [ "#cdd6f4" ];
        searchingActiveBorderColor = [ "#f9e2af" ];
      };
    };
  };

  home.persistence = {
    "${my.vars.persistence.home.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".local/state/lazygit";
        method = "symlink";
      }
    ];
  };

}
