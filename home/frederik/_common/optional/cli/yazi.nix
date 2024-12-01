{ pkgs, ... }:
{

  home.shellAliases = {
    n = "yy";
    nnn = "yy";
  };

  home.packages = with pkgs; [ ueberzugpp ];
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    catppuccin.enable = true;
    settings = {
      manager = {
        show_hidden = true;
        sort_dir_first = true;
        show_symlink = true;
      };
    };
  };

}
