{ pkgs, pkgs-system, ... }:
let
  lua51 = pkgs.lua5_1;
  lua51bin = pkgs.writeShellScriptBin "lua5.1" ''
    exec ${lua51}/bin/lua "$@"
  '';
in
{

  home.packages = with pkgs; [
    lua
    luarocks
    lua51bin
    pkgs-system.unstable.stylua
  ];

}
