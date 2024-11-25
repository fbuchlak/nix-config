{ my, config, ... }:
{

  programs.firefox = {
    enable = true;
    policies = {
      AppAutoUpdate = false;
      ExtensionUpdate = false;
      BackgroundAppUpdate = false;

      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;

      OfferToSaveLogins = false;
      DontCheckDefaultBrowser = true;
    };
  };

  xdg.mimeApps.defaultApplications = {
    "text/html" = [ "firefox.desktop" ];
    "text/xml" = [ "firefox.desktop" ];
    "x-scheme-handler/http" = [ "firefox.desktop" ];
    "x-scheme-handler/https" = [ "firefox.desktop" ];
  };

  home.persistence = {
    "${my.vars.persistence.home.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".mozilla/firefox";
        method = "symlink";
      }
    ];
    "${my.vars.persistence.cache.mnt}${config.home.homeDirectory}".directories = [
      {
        directory = ".cache/mozilla/firefox";
        method = "symlink";
      }
    ];
  };

}
