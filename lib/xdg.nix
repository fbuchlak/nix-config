{ lib }:
let
  relativePath =
    config: path: (lib.removePrefix "/" (lib.removePrefix "${config.home.homeDirectory}/" path));
  configPath = config: path: (lib.removeSuffix "/" "${config.xdg.configHome}/${path}");
  cachePath = config: path: (lib.removeSuffix "/" "${config.xdg.cacheHome}/${path}");
  statePath = config: path: (lib.removeSuffix "/" "${config.xdg.stateHome}/${path}");
  dataPath = config: path: (lib.removeSuffix "/" "${config.xdg.dataHome}/${path}");
  homePath = config: path: (lib.removeSuffix "/" "${config.home.homeDirectory}/${path}");
in
{

  inherit
    relativePath
    configPath
    cachePath
    statePath
    dataPath
    homePath
    ;

  configPathRel = config: path: (relativePath config (configPath config path));
  cachePathRel = config: path: (relativePath config (cachePath config path));
  statePathRel = config: path: (relativePath config (statePath config path));
  dataPathRel = config: path: (relativePath config (dataPath config path));
  homePathRel = config: path: (relativePath config (homePath config path));

}
