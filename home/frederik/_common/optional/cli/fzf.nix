{ lib, pkgs, ... }:
let
  fzfFdExcludes = lib.concatStrings (
    builtins.map (value: " --exclude ${value}") [
      ".cache"
      ".local"
      ".cargo"
      ".xdgtmp"
      ".mozilla"
      ".nix-defexpr"
      ".nix-profile"
    ]
  );
in
{

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "${pkgs.fd}/bin/fd -HL -t d --min-depth 1 --max-depth=4 ${fzfFdExcludes}";
    fileWidgetCommand = "${pkgs.fd}/bin/fd -HL -t f --min-depth 1 --max-depth=32 ${fzfFdExcludes}";
  };

}
