{
  my,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
{

  imports = lib.flatten [
    (my.lib.files.nix ./.)
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = lib.mkDefault false;
  };

  programs.fuse.userAllowOther = true;
  home-manager.extraSpecialArgs = {
    inherit my inputs outputs;
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
