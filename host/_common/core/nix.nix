_: {
  nix = {

    settings = {
      connect-timeout = 5; # binary cache substituter connection timeout
      fallback = false; # build from source if a binary substitute fails

      min-free = 128 * 1024 * 1024; # When free disk space drops below 128M
      max-free = 1024 * 1024 * 1024; # perform gc until 1024M is available.
      auto-optimise-store = true; # Optimise store on every build.

      log-lines = 25; # show more debug context
      warn-dirty = false; # do not show warnings about dirty tree

      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # use-xdg-base-directories = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

  };
}
