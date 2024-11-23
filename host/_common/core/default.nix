{
  my,
  lib,
  pkgs,
  outputs,
  ...
}:
{

  imports = lib.flatten [
    (my.lib.files.nix ./.)
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = lib.mkDefault false;
  };

  programs.git.enable = true;
  programs.zsh.enable = true;
  programs.nano.enable = false;

  environment.systemPackages = with pkgs; [
    vim
    git
    curl
    wget
    rsync

    coreutils-full
    findutils
    diffutils

    gawk
    gnugrep
    gnupatch
    gnused
    gnutar
  ];

}
