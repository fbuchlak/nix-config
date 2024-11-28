{
  my,
  lib,
  config,
  ...
}:
{

  home.shellAliases = {
    lg = "lazygit";
  };

  programs.git = {
    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = lib.mkDefault "always";
      };
      catppuccin.enable = true;
    };
    aliases = {
      st = "status";
    };
  };

  programs.lazygit = {
    enable = true;
    catppuccin.enable = true;
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
