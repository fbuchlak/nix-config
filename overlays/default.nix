{ my, inputs, ... }:
let
  inherit (my.lib.files) patches;
in
{

  additions = final: _prev: import ../packages final.pkgs;

  modifications = _final: prev: {

    dmenu = prev.dmenu.overrideAttrs {
      version = "5.3";
      patches = patches ./patches/dmenu/5.3;
    };

    dwm = prev.dwm.overrideAttrs {
      version = "6.5";
      patches = patches ./patches/dwm/6.5;
    };

    st = prev.st.overrideAttrs {
      version = "0.9.2";
      patches = patches ./patches/st/0.9.2;
    };

  };

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
