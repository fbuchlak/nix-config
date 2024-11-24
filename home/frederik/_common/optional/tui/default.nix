{ my, pkgs, ... }:
{

  imports = my.lib.files.nix ./.;

  home.packages = with pkgs; [
    tmux
    htop
    lazygit
  ];

}
