{
  my,
  pkgs,
  config,
  ...
}:
let
  inherit (my.lib) xdg;
in
{

  home.sessionVariables.CARGO_HOME = xdg.dataPath config "cargo";

  home.packages = with pkgs; [
    cargo
  ];

  persist.home.directories.data = [ "cargo" ];

}
