{ pkgs-system, ... }:
{
  home.packages = with pkgs-system.unstable; [
    hyperfine
  ];
}
