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
    settings.git.paging = lib.mkIf deltaEnabled {
      pager = "${pkgs.delta}/bin/delta --paging=never";
    };
  };
  catppuccin.lazygit.enable = true;

  persist.home.directories.state = lib.mkIf enabled [ "lazygit" ];

}
