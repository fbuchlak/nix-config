{ pkgs, ... }:
{

  home.packages = with pkgs; [
    awscli2
  ];

  persist.home.directories.home = [ ".aws" ];

}
