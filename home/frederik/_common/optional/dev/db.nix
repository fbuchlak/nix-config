{ pkgs, pkgs-system, ... }:
{

  home.packages =
    with pkgs;
    [
      postgresql
      mysql84
      sqlite

      dbeaver-bin
    ]
    ++ (with pkgs-system.unstable; [
      mycli
      pgcli
    ]);

  persist.home.directories.data = [ "DBeaverData" ];

}
