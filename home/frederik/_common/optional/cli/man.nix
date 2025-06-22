{ lib, pkgs-system, ... }:
let
  inherit (pkgs-system) unstable;
  tldr = unstable.tlrc;
in
{

  home.packages = [ tldr ];

  programs.navi = {
    package = unstable.navi;
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      client.tealdeer = true;
    };
  };

  persist.home.directories.data = [ "navi" ];
  persist.cache.directories.cache = [ "tlrc" ];

  programs.zsh.initContent = lib.mkOrder 1000 ''
    function __zshrc_navi_load () {
        eval $(${unstable.navi}/bin/navi widget zsh)
        bindkey '^V' _navi_widget
    }
    zvm_after_init_commands+=(__zshrc_navi_load)
  '';

  services.tldr-update = {
    enable = true;
    period = "weekly";
    package = tldr;
  };

}
