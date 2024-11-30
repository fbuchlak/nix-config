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
          (builtins.map (
            mountpoint:
            let
              home = "${mountpoint}${user.home}";
              owner = "${user.name}:${user.group}";
            in
            ''
              if [ ! -d "${home}" ] ; then
                  echo "Creating '${home}' directory"
                  mkdir -p "${home}"
                  echo "Setting owner of '${home}' to '${owner}'"
                  chown -R "${owner}" "${home}"
              fi
            ''
          ) (builtins.map (subvolume: subvolume.mnt) (attrValues my.vars.persistence)))
        ) (builtins.filter (user: user.isNormalUser) (attrValues config.users.users))
      )
    );

}
