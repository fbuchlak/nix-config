{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "autogram-na-statnych-weboch" = buildFirefoxXpiAddon {
      pname = "autogram-na-statnych-weboch";
      version = "2.0.3";
      addonId = "{66b46521-828d-4184-a038-af14d9e5cdf3}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4310887/autogram_na_statnych_weboch-2.0.3.xpi";
      sha256 = "00cb3edb7a95964ef85faf2774e72d1626b17c7060a56cba5f1ce5878e0e2056";
      meta = with lib;
      {
        homepage = "https://github.com/slovensko-digital/autogram-extension";
        description = "The extension enables the use of signer application Autogram by Slovensko.Digital on slovak government portals.";
        mozPermissions = [
          "storage"
          "https://www.slovensko.sk/*"
          "https://schranka.slovensko.sk/*"
          "https://pfseform.financnasprava.sk/*"
          "https://www.financnasprava.sk/*"
          "https://cep.financnasprava.sk/*"
          "https://www.cep.financnasprava.sk/*"
          "https://eformulare.socpoist.sk/*"
          "https://sluzby.orsr.sk/*"
        ];
        platforms = platforms.all;
      };
    };
  }