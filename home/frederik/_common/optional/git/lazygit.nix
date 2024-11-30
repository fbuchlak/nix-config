{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config) programs;
  enabled = programs.lazygit.enable;
  deltaEnabled = programs.git.delta.enable;
in
{

  home.shellAliases = lib.mkIf enabled {
    lg = "lazygit";
  };

  programs.lazygit = {
    enable = lib.mkDefault true;
    catppuccin.enable = true;
    settings.git.paging = lib.mkIf deltaEnabled {
      pager = "${pkgs.delta}/bin/delta --paging=never";
    };
  };

  persist.home.directories.state = lib.mkIf enabled [ "lazygit" ];

}
