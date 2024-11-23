_: {

  sysadmin = "frederik";

  persistence = builtins.listToAttrs (
    builtins.map
      (name: {
        inherit name;
        value = {
          vol = "@persistent-${name}";
          mnt = "/persistent/${name}";
        };
      })
      [
        "system"
        "cache"
        "logs"
        "virt"
        "data"
        "home"
      ]
  );

}
