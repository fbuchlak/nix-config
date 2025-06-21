{ ... }:
{
  imports = [

    _common/core

    _common/optional/desktops/xserver
    _common/optional/browsers
    _common/optional/nvim
    _common/optional/git
    _common/optional/gui
    _common/optional/cli
    _common/optional/dev

    _common/optional/virt/podman.nix

  ];

  persist.cache.directories.cache = [ "nix" ];

}
