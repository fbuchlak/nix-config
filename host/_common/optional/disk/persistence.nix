{
  my,
  lib,
  inputs,
  config,
  ...
}:
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

  # Create user home directories for every persistent mount point
  # so home manager can create it's own directories inside
  system.activationScripts.create-persistent-user-home-directories.text =
    with lib;
    concatLines (
      flatten (
        builtins.map (
          user:
          (builtins.map (mountpoint: ''
            if [ ! -d "${mountpoint}${user.home}" ] ; then
                echo "Creating '${mountpoint}${user.home}' directory"
                mkdir -p "${mountpoint}${user.home}"
                echo "Setting owner of '${mountpoint}${user.home}' to '${user.name}:${user.group}'"
                chown -R "${user.name}:${user.group}" "${mountpoint}${user.home}"
            fi
          '') (builtins.map (subvolume: subvolume.mnt) (attrValues my.vars.persistence)))
        ) (builtins.filter (user: user.isNormalUser) (attrValues config.users.users))
      )
    );

}
