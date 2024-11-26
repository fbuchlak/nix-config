{
  pkgs,
  inputs,
  system,
  ...
}:
{
  pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
    src = ../.;
    excludes = [
      "overlays/patches"
      "home/frederik/_common/optional/desktops/xserver/patches"
    ];
    hooks = {

      detect-private-keys.enable = true;
      detect-aws-credentials.enable = true;

      check-symlinks.enable = true;
      check-case-conflicts.enable = true;
      check-vcs-permalinks.enable = true;
      check-merge-conflicts.enable = true;
      check-added-large-files.enable = true;
      check-executables-have-shebangs.enable = true;
      check-shebang-scripts-are-executable.enable = true;
      forbid-new-submodules.enable = true;

      end-of-file-fixer.enable = true;
      mixed-line-endings.enable = true;
      fix-byte-order-marker.enable = true;
      trim-trailing-whitespace.enable = true;

      shfmt.enable = true;
      check-toml.enable = true;
      nixfmt-rfc-style = {
        enable = true;
        package = pkgs.nixfmt-rfc-style;
      };

      nil.enable = true;
      statix.enable = true;
      deadnix.enable = true;

      typos.enable = true;
      markdownlint.enable = true;

    };
  };
}
