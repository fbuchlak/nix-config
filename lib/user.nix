_:
let
  get = config: username: config.users.users.${username};
in
{

  inherit get;

  home = config: username: (get config username).home;
  name = config: username: (get config username).name;
  group = config: username: (get config username).group;

  filterGroups =
    config: groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;

}
