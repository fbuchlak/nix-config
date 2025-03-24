{ my, lib, ... }:
{

  imports = my.lib.files.nix ./.;

  programs.git = {
    delta = {
      enable = lib.mkDefault true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
      };
    };
    aliases = {
      st = "status";
    };
  };

  catppuccin.delta.enable = true;

}
