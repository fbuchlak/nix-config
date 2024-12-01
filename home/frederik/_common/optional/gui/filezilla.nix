{ pkgs, ... }:
{

  home.packages = with pkgs; [ filezilla ];
  persist.home.directories.config = [ "filezilla" ];
  persist.cache.directories.cache = [ "filezilla" ];

}
