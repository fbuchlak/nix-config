{
  my,
  lib,
  config,
  ...
}:
let
  inherit (my.lib) xdg;
  enabled = config.programs.bash.enable;
in
{

  programs.bash = {
    enable = lib.mkDefault false;
    enableCompletion = true;
    historyFile = xdg.dataPath config "bash/history";
    historyFileSize = 20000;
  };

  persist.home.directories.data = lib.mkIf enabled [ "bash" ];

}
