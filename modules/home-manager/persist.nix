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
  home = config.home.homeDirectory;
  relativePaths = paths: builtins.map (file: lib.removePrefix "${home}/" file) paths;

  mkSubvolumePersistOption = name: {
    allowOther = mkOption {
      type = types.bool;
      default = true;
    };
    files = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A list of files in home directory which
        should be persisted in "${name}" subvolume.
      '';
    };
    bindfsDirectories = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A list of directories in home directory which
        should be persisted in "${name}" subvolume
        with bindfs mount.
      '';
    };
    symlinkDirectories = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = ''
        A list of directories in home directory which
        should be persisted in "${name}" subvolume
        with symlink.
      '';
    };
  };
in
{

  options.persist = mapAttrs (name: _: mkSubvolumePersistOption name) persistence;

  config = {
    home.persistence = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "${persistence.${name}.mnt}${home}" {
        inherit (value) allowOther;
        files = relativePaths value.files;
        directories =
          builtins.map (directory: {
            inherit directory;
            method = "bindfs";
          }) (relativePaths value.bindfsDirectories)
          ++ builtins.map (directory: {
            inherit directory;
            method = "symlink";
          }) (relativePaths value.symlinkDirectories);
      }
    ) cfg;
  };

}
