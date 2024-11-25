{ my, config, ... }:
{

  home.persistence = {

    "${my.vars.persistence.cache.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".cache/containers";
        method = "symlink";
      }
    ];

    "${my.vars.persistence.virt.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".local/share/containers";
        method = "symlink";
      }
    ];

  };

}
