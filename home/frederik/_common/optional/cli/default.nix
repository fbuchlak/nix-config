{ my, pkgs, ... }:
{

  imports = my.lib.files.nix ./.;

  home.shellAliases = {
    top = "htop";
  };

  home.packages = with pkgs; [
    htop
  ];

}
