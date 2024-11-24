{ my, config, ... }:
{

  programs.brave = {
    enable = true;
    commandLineArgs = [ "--no-default-browser-check" ];
  };

  home.persistence = {
    "${my.vars.persistence.home.mnt}${config.home.homeDirectory}".directories = [
      ".config/BraveSoftware/Brave-Browser"
    ];
    "${my.vars.persistence.cache.mnt}${config.home.homeDirectory}".directories = [
      ".cache/BraveSoftware/Brave-Browser"
    ];
  };
}
