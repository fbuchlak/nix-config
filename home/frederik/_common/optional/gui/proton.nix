{ pkgs-system, ... }:
{

  home.packages = with pkgs-system.unstable; [
    proton-pass
    protonmail-desktop
  ];

  persist.home.directories.config = [
    "Proton Pass"
    "Proton Mail"
  ];
  persist.cache.directories.cache = [
    "Proton"
  ];

}
