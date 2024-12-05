{ pkgs, ... }:
{

  home.packages = with pkgs; [
    php84
    php84Packages.composer
    phpactor
  ];

  persist.home.directories.data = [ "composer" ];
  persist.cache.directories.cache = [
    "phpactor"
    "composer"
  ];

}
