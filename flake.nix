{

  description = "Nix Config";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
    hardware.url = "github:nixos/nixos-hardware/master";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      inherit (self) outputs;
      inherit (nixpkgs) lib pkgs;
      my = {
        lib = import ./lib { inherit lib pkgs; };
        vars = import ./vars { };
      };

      specialArgs = {
        inherit
          my
          inputs
          outputs
          nixpkgs
          ;
      };
    in
    {

      overlays = import ./overlays { inherit my inputs; };
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./packages { inherit pkgs; }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./checks { inherit pkgs inputs system; }
      );
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        in
        import ./shell.nix { inherit checks pkgs; }
      );

      nixosConfigurations = {

        vesna = lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./host/vesna ];
        };

      };

    };

}
