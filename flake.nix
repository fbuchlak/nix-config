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

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:kaylorben/nixcord";
    catppuccin.url = "github:catppuccin/nix";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    mozilla-addons-to-nix.url = "sourcehut:~rycee/mozilla-addons-to-nix";

    # Private
    nix-secrets = {
      url = "git+ssh://git@gitlab.com/fbuchlak/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
    nix-private-config = {
      url = "git+ssh://git@github.com/fbuchlak/nix-private-config.git?ref=main&shallow=1";
      flake = true;
    };

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

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

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
        import ./shell.nix { inherit inputs checks pkgs; }
      );

      nixosConfigurations = {

        vesna = lib.nixosSystem {
          inherit specialArgs;
          modules = [ ./host/vesna ];
        };

      };

    };

}
