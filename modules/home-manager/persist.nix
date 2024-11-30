{
  my,
  lib,
  config,
  ...
}:
let
  inherit (lib) types mkOption mapAttrs;
  inherit (my.lib) xdg;
  inherit (my.vars) persistence;

  cfg = config.persist;

  pathsConfig = {
    config = xdg.configPath config "";
    cache = xdg.cachePath config "";
    state = xdg.statePath config "";
    data = xdg.dataPath config "";
    home = xdg.homePath config "";
  };

  mkFileOption =
    subvolume: path:
    mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A list of files in home directory which
        should be persisted in "${subvolume}" subvolume
        to path "${path}".
      '';
    };

  mkFileOptions =
    subvolume: lib.mapAttrsRecursive (_: path: (mkFileOption subvolume path)) pathsConfig;

  mkDirectoryOption =
    subvolume: type: path:
    mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A list of directories in home directory which
        should be persisted in "${subvolume}" subvolume
        with "${type}" to path "${path}".
      '';
    };

  mkDirectoryOptions =
    subvolume: type:
    lib.mapAttrsRecursive (_: path: (mkDirectoryOption subvolume type path)) pathsConfig;

  mkSubvolumePersistOption = subvolume: {
    allowOther = mkOption {
      type = types.bool;
      default = true;
    };
    files = mkFileOptions subvolume;
    directories = mkDirectoryOptions subvolume "symlink";
    directoriesBindfs = mkDirectoryOptions subvolume "bindfs";
  };

  mapByPathsConfig =
    with lib;
    value:
    flatten (
      attrValues (
        mapAttrs (
          key: path: (builtins.map (p: (xdg.relativePath config "${path}/${p}")) value.${key})
        ) pathsConfig
      )
    );
in
{

  options.persist = mapAttrs (name: _: mkSubvolumePersistOption name) persistence;

  config = {
    xdg.enable = lib.mkForce true;
    home.persistence = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "${persistence.${name}.mnt}${(xdg.homePath config "")}" {
        inherit (value) allowOther;
        files = mapByPathsConfig value.files;
        directories =
          (builtins.map (directory: {
            inherit directory;
            method = "bindfs";
          }) (mapByPathsConfig value.directoriesBindfs))
          ++ (builtins.map (directory: {
            inherit directory;
            method = "symlink";
          }) (mapByPathsConfig value.directories));
      }
    ) cfg;
  };

}
