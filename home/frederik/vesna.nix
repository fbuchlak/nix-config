{ my, config, ... }:
{
  imports = [
    _common/core

    _common/optional/desktops/xserver

    _common/optional/browsers
    _common/optional/git
    _common/optional/tui

    _common/optional/virt/podman.nix

  ];

  home.persistence = {
    "${my.vars.persistence.home.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".aws";
        method = "symlink";
      }
    ];
  };

}
