{ inputs, ... }:
{

  imports = [ inputs.impermanence.nixosModules.impermanence ];

  persist.system.files = [ "/etc/machine-id" ];
  persist.system.directories = [
    "/etc/nixos"
    "/var/lib/nixos"
    "/var/lib/systemd/coredump"
    "/var/spool"
    "/var/tmp"
  ];
  persist.cache.directories = [ "/var/cache" ];
  persist.logs.directories = [ "/var/log" ];

}
