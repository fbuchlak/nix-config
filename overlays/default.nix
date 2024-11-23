{ inputs, ... }:
{

  additions = final: _prev: import ../packages final.pkgs;

  stable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-stable {
      inherit (final) system;
      config.allowUnfree = false;
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;
      config.allowUnfree = false;
    };
  };

}
