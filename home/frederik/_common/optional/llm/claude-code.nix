{
  my,
  config,
  pkgs-system,
  ...
}:
let
  inherit (my.lib) xdg;
in
{

  home.packages = with pkgs-system.unstable; [ claude-code ];
  persist.home.directories.home = [ (xdg.homePathRel config ".claude") ];

}
