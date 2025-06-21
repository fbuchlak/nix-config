{ pkgs-system, ... }:
{

  home.packages = with pkgs-system.unstable; [

    jq
    yq
    htmlq

    quicktype
    oath-toolkit

    tokei

  ];

}
