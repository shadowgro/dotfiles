{
  description = "A flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    import-tree.url = "github:denful/import-tree";
    # mangowm = {
    #   url = "github:mangowm/mango";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # noctalia = {
    #   url = "github:noctalia-dev/noctalia";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake/2656d974602749ca5594b133e3022a241ab5d4e0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rom = {
      url = "github:manic-systems/rom";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nix-index-database = {
    #   url = "github:nix-community/nix-index-database";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprfm = {
    #   url = "github:soyeb-jim285/hyprfm";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    yet-another-monochrome-icon-set = {
      url = "git+https://bitbucket.org/dirn-typo/yet-another-monochrome-icon-set.git";
      flake = false;
    };
    # orchis-kde = {
    #   url = "github:vinceliuice/Orchis-kde";
    #   flake = false;
    # };
    clip-bridge-src = {
      url = "github:noctisynth/clip-bridge";
      flake = false;
    };
    zsh-edit-select-src = {
      url = "github:Michael-Matta1/zsh-edit-select";
      flake = false;
    };
    # wine-d2d1-src = {
    #   url = "github:giang17/wine/8a627366c023fe7c4e42476fdb8cc6c7cafa9463";
    #   # url = "github:giang17/wine/d2d1-dcomp-11.0";
    #   flake = false;
    # };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs: {

    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        stable = import nixpkgs-stable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
      modules = [
        ./configuration.nix
        # nix-index-database.nixosModules.default
        home-manager.nixosModules.home-manager {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "backup";
            users.kirill = {
              home.username = "kirill";
              home.homeDirectory = "/home/kirill";
              home.stateVersion = "26.05";
              programs.home-manager.enable = true;
            };
          };
        }
      ];
    };
  };
}
