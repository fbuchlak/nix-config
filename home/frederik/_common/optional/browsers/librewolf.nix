{
  pkgs,
  pkgs-system,
  inputs,
  ...
}:
{

  programs.librewolf = {
    enable = true;
    profiles = {

      frederik = {
        extensions.packages =
          with inputs.firefox-addons.packages."${pkgs.system}";
          [
            # ads/privacy
            ublock-origin
            canvasblocker
            istilldontcareaboutcookies
            # passwords
            proton-pass
            # youtube
            sponsorblock
            # ui
            tridactyl
            darkreader
            # development
            react-devtools
            vue-js-devtools
            angular-devtools
          ]
          ++ (with pkgs-system.custom-firefox-addons; [
            autogram-na-statnych-weboch
          ]);
      };

    };
  };

}
