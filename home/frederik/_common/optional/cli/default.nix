{ my, pkgs, ... }:
{

  imports = my.lib.files.nix ./.;

  home.shellAliases = {
    bc = "fend";
    top = "htop";
  };

  home.packages = with pkgs; [
    fend
    htop
    btop
  ];

}
