{
  pkgs,
  pkgs-system,
  inputs,
  ...
}:
let
  firefox-addons = inputs.firefox-addons.packages."${pkgs.system}";
  inherit (pkgs-system) custom-firefox-addons;
in
{

  programs.librewolf = {
    enable = true;
    nativeMessagingHosts = with pkgs; [ tridactyl-native ];
    profiles = {

      default = {
        id = 9999;
        isDefault = false;
      };

      frederik = {
        id = 0;
        isDefault = true;

        extensions = {
          force = true;
          packages =
            with firefox-addons;
            [
              # ads/privacy
              ublock-origin
              canvasblocker
              istilldontcareaboutcookies
              # passwords
              proton-pass
              # youtube
              sponsorblock
              youtube-nonstop
              return-youtube-dislikes
              # other
              tridactyl
              darkreader
            ]
            ++ (with custom-firefox-addons; [
              autogram-na-statnych-weboch
            ]);
          settings = {
            "${firefox-addons.tridactyl.addonId}".settings = {
              userconfig = {
                theme = "midnight";
              };
            };
          };
        };

        search = {
          force = true;
          default = "ddg";
          privateDefault = "ddg";
          engines = {
            ddg = { };
            google.metaData.hidden = true;
          };
        };

        settings = {
          # Enable extensions by default
          "extensions.autoDisableScopes" = 0;
          "extensions.update.enabled" = false;
          # Privacy
          "webgl.disabled" = false; # https://librewolf.net/docs/settings/#enable-webgl
          "identity.fxaccounts.enabled" = false;
          "privacy.resistFingerprinting.letterboxing" = true; # https://librewolf.net/docs/settings/#enable-letterboxing
          # Sane defaults for browser
          "middlemouse.paste" = false;
          "browser.download.useDownloadDir" = false; # always ask where to save files
          "browser.ctrlTab.sortByRecentlyUsed" = true;
          "browser.tabs.closeWindowWithLastTab" = false;
        };

      };

    };

    policies = {
      AppAutoUpdate = false;
      BackgroundAppUpdate = false;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
        EmailTracking = true;
      };
      OfferToSaveLogins = false;
      DontCheckDefaultBrowser = true;
      ExtensionUpdate = false;
    };
  };

}
