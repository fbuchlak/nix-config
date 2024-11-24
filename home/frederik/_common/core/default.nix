{
  my,
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (my.vars) persistence;
in
{
  imports = lib.flatten [
    inputs.impermanence.nixosModules.home-manager.impermanence
    (my.lib.files.nix ./.)
  ];

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

    persistence = {

      "${persistence.home.mnt}${config.home.homeDirectory}" = {
        allowOther = true;
        directories = [
          ".ssh"
          "projects"
          "nix-config"
        ];
      };

      "${persistence.data.mnt}${config.home.homeDirectory}" = {
        allowOther = true;
        directories = [
          "media"
          "downloads"
        ];
        files = [
          ".bash_history"
          ".zsh_history"
        ];
      };

      "${my.vars.persistence.system.mnt}${config.home.homeDirectory}".allowOther = true;
      "${my.vars.persistence.cache.mnt}${config.home.homeDirectory}".allowOther = true;
      "${my.vars.persistence.logs.mnt}${config.home.homeDirectory}".allowOther = true;
      "${my.vars.persistence.virt.mnt}${config.home.homeDirectory}".allowOther = true;

    };

  };

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      # Data
      download = "${config.home.homeDirectory}/documents";
      documents = "${config.home.homeDirectory}/downloads";
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
