{
  my,
  lib,
  config,
  ...
}:
let
  inherit (lib) types mkOption mapAttrs;
  inherit (my.vars) persistence;
  cfg = config.persist;
  mkSubvolumePersistOption = name: {
    hideMounts = mkOption {
      type = types.bool;
      default = true;
    };
    neededForBoot = mkOption {
      type = types.bool;
      default = true;
    };
    files = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A list of files which should be persisted in "${name}" subvolume.
      '';
    };
    directories = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A list of directories which should be persisted in "${name}" subvolume.
      '';
    };
  };
in
{

  options.persist = mapAttrs (name: _: mkSubvolumePersistOption name) persistence;

  config = {
    fileSystems = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "${persistence.${name}.mnt}" {
        inherit (value) neededForBoot;
      }
    ) cfg;
    environment.persistence = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "${persistence.${name}.mnt}" {
        inherit (value) hideMounts files directories;
      }
    ) cfg;
  };

}
