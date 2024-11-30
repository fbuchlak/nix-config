{ lib, ... }:
{

  config = import ./config.nix { inherit lib; };
  files = import ./files.nix { inherit lib; };
  user = import ./user.nix { };
  xdg = import ./xdg.nix { inherit lib; };

}
