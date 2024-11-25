{ my, config, ... }:
{

  programs.brave = {
    enable = true;
    commandLineArgs = [ "--no-default-browser-check" ];
  };

  home.persistence = {
    "${my.vars.persistence.home.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".config/BraveSoftware/Brave-Browser";
        method = "symlink";
      }
    ];
    "${my.vars.persistence.cache.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".cache/BraveSoftware/Brave-Browser";
        method = "symlink";
      }
    ];
  };
}
