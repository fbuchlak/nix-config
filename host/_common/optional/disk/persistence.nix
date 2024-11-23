{ my, inputs, ... }:
let
  inherit (my.vars) persistence;
in
{

  imports = [ inputs.impermanence.nixosModules.impermanence ];

  config = {

    fileSystems."${persistence.system.mnt}".neededForBoot = true;
    environment.persistence."${persistence.system.mnt}" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/spool"
        "/var/tmp"
      ];
      files = [ "/etc/machine-id" ];
    };

    fileSystems."${persistence.cache.mnt}".neededForBoot = true;
    environment.persistence."${persistence.cache.mnt}" = {
      hideMounts = true;
      directories = [ "/var/cache" ];
    };

    fileSystems."${persistence.logs.mnt}".neededForBoot = true;
    environment.persistence."${persistence.logs.mnt}" = {
      hideMounts = true;
      directories = [ "/var/log" ];
    };

    fileSystems."${persistence.virt.mnt}".neededForBoot = true;
    environment.persistence."${persistence.virt.mnt}".hideMounts = true;

    fileSystems."${persistence.data.mnt}".neededForBoot = true;
    environment.persistence."${persistence.data.mnt}".hideMounts = true;

    fileSystems."${persistence.home.mnt}".neededForBoot = true;
    environment.persistence."${persistence.home.mnt}".hideMounts = true;

  };

}
