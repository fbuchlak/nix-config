{ pkgs, ... }:
{

  home.shellAliases = {
    lg = "lazygit";
  };

  programs.git = {
    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
      };
      catppuccin.enable = true;
    };
    aliases = {
      st = "status";
    };
  };

  programs.lazygit = {
    enable = true;
    catppuccin.enable = true;
    settings.git.paging.pager = "${pkgs.delta}/bin/delta --paging=never";
  };
  programs.bat.catppuccin.enable = true;

  persist.home.symlinkDirectories = [ ".local/state/lazygit" ];

}
