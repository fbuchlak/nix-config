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
    (builtins.attrValues outputs.nixosModules)
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = lib.mkDefault false;
  };

  programs.fuse.userAllowOther = true;

  home-manager.useGlobalPkgs = lib.mkForce false;
  home-manager.extraSpecialArgs = {
    inherit my inputs outputs;
    pkgs-system = pkgs;
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

    coreutils
    findutils
    diffutils

    gawk
    gnugrep
    gnupatch
    gnused
    gnutar
  ];

}
