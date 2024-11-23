{ lib, ... }:
{

  boot.tmp.cleanOnBoot = lib.mkDefault true;

  boot.loader = {
    timeout = lib.mkDefault 3;
    systemd-boot = {
      enable = lib.mkDefault true;
      editor = lib.mkDefault false;
      consoleMode = lib.mkDefault "max";
      configurationLimit = lib.mkDefault 10;
    };
  };

}
