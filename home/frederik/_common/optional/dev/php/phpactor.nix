{
  my,
  pkgs,
  config,
  ...
}:
let
  inherit (my.lib) xdg;
  templates = builtins.attrNames (builtins.readDir ./phpactor/templates);
in
{

  home.packages = with pkgs; [ phpactor ];

  home.file."${xdg.configPathRel config "phpactor/templates"}".source = ./phpactor/templates;
  home.file."${xdg.configPathRel config "phpactor/phpactor.yml"}".text = ''
    indexer.follow_symlinks: true

    code_transform.import_globals: true
    code_transform.refactor.generate_accessor.prefix: "get"
    code_transform.refactor.generate_accessor.upper_case_first: true
    code_transform.refactor.generate_mutator.fluent: false

    language_server_worse_reflection.inlay_hints.enable: true
    language_server_worse_reflection.inlay_hints.types: true
    language_server_worse_reflection.inlay_hints.params: true

    code_transform.class_new.variants:
    ${builtins.concatStringsSep "\n" (map (name: "  ${name}: ${name}") templates)}
  '';

  persist.cache.directories.cache = [ "phpactor" ];

}
