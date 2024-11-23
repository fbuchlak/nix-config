{ lib }:
{

  nix =
    path:
    builtins.map (file: "${path}/${file}") (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: type:
          ((type == "directory") || ((path != "default.nix") && (lib.strings.hasSuffix ".nix" path)))
        ) (builtins.readDir path)
      )
    );

}
