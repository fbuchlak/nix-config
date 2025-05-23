{
  my,
  lib,
  pkgs,
  config,
  inputs,
  outputs,
  ...
}:
let
  inherit (my.lib) xdg;
  xdgUnusedDirsPathRel = xdg.statePathRel config "xdg-unused-dirs";
  documentsPathRel = xdg.homePathRel config "documents";
  downloadPathRel = xdg.homePathRel config "downloads";
  mediaPathRel = xdg.homePathRel config "media";
in
{
  imports = lib.flatten [
    (builtins.attrValues outputs.homeManagerModules)
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.catppuccin.homeModules.catppuccin
    (my.lib.files.nix ./.)
  ];

  catppuccin.flavor = "mocha";

  home = {
    stateVersion = lib.mkDefault "24.05";

    username = lib.mkDefault "frederik";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    preferXdgDirectories = true;

    packages = builtins.attrValues {
      inherit (pkgs)
        curl
        wget
        gnumake

        bc
        jq
        yq

        fd
        fzf
        ripgrep

        parallel
        libxml2
        ;
    };
  };

  home.shellAliases =
    with builtins;
    listToAttrs (
      map
        (value: {
          name = value;
          value = "sudo ${value}";
        })
        [
          "mount"
          "umount"
          "poweroff"
          "reboot"
          "shutdown"
          "showkey"
        ]
    );

  persist.home.directories.home = [
    (xdg.homePathRel config "nix")
    (xdg.homePathRel config ".ssh")
    (xdg.homePathRel config "projects")
  ];

  persist.data.directories.home = [
    documentsPathRel
    downloadPathRel
    mediaPathRel
  ];

  xdg = {
    enable = true;
    mimeApps.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      # Data
      download = xdg.homePath config downloadPathRel;
      documents = xdg.homePath config documentsPathRel;
      # Media
      music = xdg.homePath config "${mediaPathRel}/audio";
      videos = xdg.homePath config "${mediaPathRel}/video";
      pictures = xdg.homePath config "${mediaPathRel}/images";
      # # Unused
      desktop = xdg.homePath config "${xdgUnusedDirsPathRel}/desktop";
      templates = xdg.homePath config "${xdgUnusedDirsPathRel}/templates";
      publicShare = xdg.homePath config "${xdgUnusedDirsPathRel}/public";
    };
  };

  programs.home-manager.enable = true;
}
