{ lib, pkgs, ... }:
{

  home.packages = with pkgs; [ eza ];

  home.shellAliases = {
    l = lib.mkDefault "eza -alh";
    ls = lib.mkDefault "eza";
    la = lib.mkDefault "eza -alh";
    ll = lib.mkDefault "eza -alh --group-directories-first";
  };

}
