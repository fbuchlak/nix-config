{
  lib,
  pkgs,
  config,
  ...
}:
let
  enabled = config.programs.bat.enable;
in
{

  home.shellAliases = lib.mkIf enabled {
    cat = "bat";
    man = "batman";
  };

  programs.bat = {
    enable = lib.mkDefault true;
    extraPackages = with pkgs.bat-extras; [
      batman
      batdiff
      batgrep
    ];
  };
  catppuccin.bat.enable = true;

  persist.cache.directories.cache = [ "bat" ];

}
