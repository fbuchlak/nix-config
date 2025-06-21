{
  my,
  pkgs-system,
  config,
  ...
}:
let
  inherit (my.lib) xdg;
in
{

  home.sessionVariables = {
    NPM_CONFIG_USERCONFIG = xdg.configPath config "npm/npmrc";
    NPM_CONFIG_CACHE = xdg.cachePath config "npm";
  };

  home.packages = with pkgs-system.unstable; [
    nodejs
    bun
    pnpm
    yarn
  ];

  xdg.configFile."npm/npmrc".text = ''
    prefix=${xdg.dataPath config "npm"}
    cache=${xdg.cachePath config "npm"}
    init-module=${xdg.configPath config "npm/config/npm-init.js"}
    logs-dir=${xdg.dataPath config "npm/logs"}
  '';

  persist.home.directories.data = [ "npm" ];
  persist.cache.directories.cache = [
    "npm"
    ".bun"
    "pnpm"
    "yarn"
    "typescript"
  ];

}
