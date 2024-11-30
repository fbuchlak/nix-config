{
  my,
  lib,
  pkgs,
  config,
  inputs,
  outputs,
  ...
}:
{
  imports = lib.flatten [
    (builtins.attrValues outputs.homeManagerModules)
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.catppuccin.homeManagerModules.catppuccin
    (my.lib.files.nix ./.)
  ];

  catppuccin.flavor = "mocha";

  home = {
    stateVersion = lib.mkDefault "24.05";

    username = lib.mkDefault "frederik";
    homeDirectory = lib.mkDefault "/home/frederik";
    preferXdgDirectories = true;

    packages = builtins.attrValues {
      inherit (pkgs)
        jq
        fd
        fzf
        ripgrep
        ;
    };
  };

  persist.home.directories.home = [
    ".ssh"
    "projects"
    "nix-config"
  ];
  persist.home.files.home = [ ".bash_history" ];
  persist.data.directories.home = [
    "documents"
    "downloads"
    "media"
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      # Data
      download = "${config.home.homeDirectory}/downloads";
      documents = "${config.home.homeDirectory}/documents";
      # Media
      music = "${config.home.homeDirectory}/media/audio";
      videos = "${config.home.homeDirectory}/media/video";
      pictures = "${config.home.homeDirectory}/media/images";
      # Unused
      desktop = "${config.home.homeDirectory}/.xdgtmp/desktop";
      templates = "${config.home.homeDirectory}/.xdgtmp/templates";
      publicShare = "${config.home.homeDirectory}/.xdgtmp/public";
    };
  };

  programs.home-manager.enable = true;
}
