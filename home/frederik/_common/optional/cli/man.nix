{ pkgs, ... }:
{

  home.packages = with pkgs; [ tldr ];

  programs.navi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
  };

  persist.home.directories.data = [ "navi" ];
  persist.cache.directories.cache = [ "tldr" ];

}
