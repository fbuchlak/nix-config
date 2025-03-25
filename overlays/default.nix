{ inputs, ... }:
{

  additions = final: _prev: import ../packages final.pkgs;

  modifications = _final: _prev: { };

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

  custom-firefox-addons = final: _prev: {
    custom-firefox-addons = final.callPackage ./custom-firefox-addons {
      inherit (inputs.firefox-addons.lib.${final.pkgs.system}) buildFirefoxXpiAddon;
    };
  };

}
