{
  my,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (my.lib) xdg;
  fzfFdExcludes = lib.concatStrings (
    builtins.map (value: " --exclude ${value}") [
      (xdg.cachePathRel config "")
      (xdg.statePathRel config "")
      (xdg.dataPathRel config "")
      (xdg.homePathRel config ".nix-defexpr")
      (xdg.homePathRel config ".nix-profile")
      (xdg.homePathRel config ".mozilla")
    ]
  );
in
{

  programs.fzf = {
    enable = true;
    catppuccin.enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd -HL -t d --min-depth 1 --max-depth=4 ${fzfFdExcludes}";
    fileWidgetCommand = "${pkgs.fd}/bin/fd -HL -t f --min-depth 1 --max-depth=32 ${fzfFdExcludes}";
  };

}
