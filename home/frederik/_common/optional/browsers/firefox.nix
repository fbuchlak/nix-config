{ lib, ... }:
{

  programs.firefox = {
    enable = true;
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
      ExtensionSettings =
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        builtins.listToAttrs [
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
          (extension "istilldontcareaboutcookies" "idcac-pub@guus.ninja")

          (extension "darkreader" "addon@darkreader.org")
          (extension "tridactyl-vim" "tridactyl.vim@cmcaine.co.uk")

          (extension "proton-pass" "78272b6fa58f4a1abaac99321d503a20@proton.me")
        ];

    };
  };

  xdg.mimeApps.defaultApplications =
    with lib;
    let
      firefox = "firefox.desktop";
      firefoxBefore = mkBefore [ firefox ];
      firefoxDefault = mkDefault [ firefox ];
    in
    {
      "x-scheme-handler/http" = firefoxBefore;
      "x-scheme-handler/https" = firefoxBefore;
      "x-scheme-handler/about" = firefoxBefore;
      "x-scheme-handler/unknown" = firefoxBefore;
      "image/*" = firefoxDefault;
      "application/pdf" = firefoxDefault;
      "application/x-extension-htm" = firefoxDefault;
      "application/x-extension-html" = firefoxDefault;
      "application/x-extension-shtml" = firefoxDefault;
      "application/xhtml+xml" = firefoxDefault;
      "application/x-extension-xhtml" = firefoxDefault;
      "application/x-extension-xht" = firefoxDefault;
    };

  persist.home.directories.home = [ ".mozilla/firefox" ];
  persist.cache.directories.cache = [
    "mozilla/firefox"
    "mesa_shader_cache"
    "mesa_shader_cache_db"
  ];

}
