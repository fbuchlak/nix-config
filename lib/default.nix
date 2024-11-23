{ lib, ... }:
{

  config = import ./config.nix { inherit lib; };

}
