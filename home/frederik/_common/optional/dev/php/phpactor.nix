{ pkgs, ... }:
{

  home.packages = with pkgs; [ phpactor ];

  persist.cache.directories.cache = [ "phpactor" ];

}
