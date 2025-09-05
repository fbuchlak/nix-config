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

  home.packages = with pkgs-system.unstable; [ aider-chat ];
  persist.home.directories.home = [ (xdg.homePathRel config ".aider") ];
  programs.git.ignores = [ "aider*" ];

}
