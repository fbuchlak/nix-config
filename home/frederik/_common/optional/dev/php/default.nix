{ pkgs, ... }:
{

  imports = [
    ./phpactor.nix
    ./symfony.nix
  ];

  home.packages = with pkgs; [
    php84
    php84Packages.composer
  ];

  persist.home.directories.data = [ "composer" ];
  persist.cache.directories.cache = [ "composer" ];

}
