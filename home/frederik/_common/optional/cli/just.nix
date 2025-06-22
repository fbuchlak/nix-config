{ lib, pkgs, ... }:
{

  home.packages = with pkgs; [ just ];
  programs.zsh.initContent = lib.mkOrder 1000 ''
    function __zshrc_just_completion () {
        source <(${pkgs.just}/bin/just --completions zsh)
    }
    zvm_after_init_commands+=(__zshrc_just_completion)
  '';

}
