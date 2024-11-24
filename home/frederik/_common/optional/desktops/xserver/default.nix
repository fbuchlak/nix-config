{ my, pkgs, ... }:
{

  imports = my.lib.files.nix ./.;

  home.file.".xinitrc".source = ./xinitrc;
  home.file.".Xresources".source = ./xresources;
  home.packages = with pkgs; [
    xclip
    scrot
    dunst
    libnotify
  ];

}
