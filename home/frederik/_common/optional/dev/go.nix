{
  my,
  pkgs,
  config,
  ...
}:
{

  home.sessionVariables.GOPATH = my.lib.xdg.dataPath config "go";

  home.packages = with pkgs; [
    go
  ];

  persist.home.directories.data = [ "go" ];
  persist.cache.directories.cache = [ "go-build" ];

}
